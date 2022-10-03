locals {
  standard_name = var.storage_name
  # standard_name = "${var.storage_name}${var.environment}"

  loc = var.override_location != "" ? var.override_location : var.resource_group.location
}

resource "azurerm_storage_account" "storage" {
  name                     = var.override_name != "" ? var.override_name : local.standard_name
  resource_group_name      = var.resource_group.name
  location                 = local.loc
  account_tier             = var.account_tier
  account_kind             = var.account_kind
  account_replication_type = var.account_replication_type
  min_tls_version          = var.min_tls_version

  dynamic "blob_properties" {
    for_each = var.blob_properties
    content {
      dynamic "cors_rule" {
        for_each = blob_properties.value.cors_rule == null ? [] : toset(blob_properties.value.cors_rule)
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }

      }
      dynamic "delete_retention_policy" {
        for_each = blob_properties.value.delete_retention_policy == null ? [] : toset(blob_properties.value.delete_retention_policy)
        content {
          days = delete_retention_policy.value.days
        }
      }
      versioning_enabled       = blob_properties.value.versioning_enabled
      change_feed_enabled      = blob_properties.value.versioning_enabled
      default_service_version  = blob_properties.value.default_service_version
      last_access_time_enabled = blob_properties.value.last_access_time_enabled
      dynamic "container_delete_retention_policy" {
        for_each = blob_properties.value.container_delete_retention_policy == null ? [] : toset(blob_properties.value.container_delete_retention_policy)
        content {
          days = container_delete_retention_policy.value.days
        }
      }
    }

  }

  # azure-cis-3.1-storage-secure-transfer-required-is-enabled
  enable_https_traffic_only = var.enable_https_traffic_only

  # azure-cis-3.3-storage-queue-logging-is-enable
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/4401#issuecomment-579400404
  dynamic "queue_properties" {
    for_each = var.enable_storage_queue_logging ? [1] : []
    content {
      logging {
        delete                = var.enable_storage_queue_logging
        read                  = var.enable_storage_queue_logging
        write                 = var.enable_storage_queue_logging
        version               = "1.0"
        retention_policy_days = 10
      }
      hour_metrics {
        enabled               = var.enable_storage_queue_logging
        include_apis          = true
        version               = "1.0"
        retention_policy_days = 10
      }
      minute_metrics {
        enabled               = var.enable_storage_queue_logging
        include_apis          = true
        version               = "1.0"
        retention_policy_days = 10
      }
    }
  }

  dynamic "static_website" {
    for_each = var.static_website_enabled ? ["true"] : []
    content {
    }
  }
}

# azure-cis-3.7.x-storage-default-network-access-rule-set-to-deny
# azure-cis-3.8.x-storage-trusted-microsoft-services-is-enabled
resource "azurerm_storage_account_network_rules" "network_rules" {
  count              = var.network_rules_default_action != "" ? 1 : 0
  storage_account_id = azurerm_storage_account.storage.id

  # https://aquasecurity.github.io/tfsec/v1.28.0/checks/azure/storage/default-action-deny/
  # tfsec:ignore:azure-storage-default-action-deny
  default_action             = var.network_rules_default_action
  ip_rules                   = var.network_rules_ip_rules
  virtual_network_subnet_ids = var.network_rules_virtual_network_subnet_ids
  bypass                     = var.network_rules_bypass
}

# azure-cis-3.x-storage-advanced-threat-protection-is-enabled
resource "azurerm_advanced_threat_protection" "advanced_threat_protection" {
  count              = var.enable_advanced_threat_protection ? 1 : 0
  target_resource_id = azurerm_storage_account.storage.id
  enabled            = var.enable_advanced_threat_protection
}

resource "azurerm_role_assignment" "azurerm_role_assignment_developer_blob_data_contributor" {
  count                = var.systemaccess_developer_group_id == "00000000-0000-0000-0000-000000000000" ? 0 : 1
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.systemaccess_developer_group_id
}

resource "azurerm_role_assignment" "azurerm_role_assignment_developer_blob_data_reader" {
  count                = var.systemaccess_developer_group_id == "00000000-0000-0000-0000-000000000000" ? 0 : 1
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.systemaccess_developer_group_id
}

resource "azurerm_role_assignment" "azurerm_role_assignment_developer_queue_data_reader" {
  count                = var.systemaccess_developer_group_id == "00000000-0000-0000-0000-000000000000" ? 0 : 1
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Queue Data Reader"
  principal_id         = var.systemaccess_developer_group_id
}

resource "azurerm_role_assignment" "azurerm_role_assignment_developer_reader_and_data_access" {
  count                = var.systemaccess_developer_group_id == "00000000-0000-0000-0000-000000000000" ? 0 : 1
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Reader and Data Access"
  principal_id         = var.systemaccess_developer_group_id
}

resource "azurerm_key_vault_secret" "primary_access_key" {
  count        = var.azurerm_key_vault == null ? 0 : 1
  name         = "${azurerm_storage_account.storage.name}-primary-access-key" # Error: "name" may only contain alphanumeric characters and dashes.
  value        = azurerm_storage_account.storage.primary_access_key
  key_vault_id = var.azurerm_key_vault.id
}

resource "azurerm_key_vault_secret" "secondary_access_key" {
  count        = var.azurerm_key_vault == null ? 0 : 1
  name         = "${azurerm_storage_account.storage.name}-secondary-access-key" # Error: "name" may only contain alphanumeric characters and dashes.
  value        = azurerm_storage_account.storage.secondary_access_key
  key_vault_id = var.azurerm_key_vault.id
}

resource "azurerm_key_vault_secret" "primary_connection_string" {
  count        = var.azurerm_key_vault == null ? 0 : 1
  name         = "${azurerm_storage_account.storage.name}-primary-connection-string" # Error: "name" may only contain alphanumeric characters and dashes.
  value        = azurerm_storage_account.storage.primary_connection_string
  key_vault_id = var.azurerm_key_vault.id
}

resource "azurerm_key_vault_secret" "secondary_connection_string" {
  count        = var.azurerm_key_vault == null ? 0 : 1
  name         = "${azurerm_storage_account.storage.name}-secondary-connection-string" # Error: "name" may only contain alphanumeric characters and dashes.
  value        = azurerm_storage_account.storage.secondary_connection_string
  key_vault_id = var.azurerm_key_vault.id
}
