locals {
  name     = var.override_name == null ? "${lower(replace(var.system_name, "-", ""))}${var.environment}st" : var.override_name
  location = var.override_location == null ? var.resource_group.location : var.override_location
}

resource "azurerm_storage_account" "storage_account" {
  name                = local.name
  location            = local.location
  resource_group_name = var.resource_group.name

  account_kind                     = var.account_kind
  account_tier                     = var.account_tier
  account_replication_type         = var.account_replication_type
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  access_tier                      = var.access_tier
  edge_zone                        = var.edge_zone

  # azure-cis-3.1-storage-secure-transfer-required-is-enabled
  enable_https_traffic_only = var.enable_https_traffic_only

  min_tls_version                 = var.min_tls_version
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  default_to_oauth_authentication = var.default_to_oauth_authentication

  is_hns_enabled = var.is_hns_enabled
  nfsv3_enabled  = var.nfsv3_enabled

  dynamic "custom_domain" {
    for_each = var.custom_domain
    content {
      name          = custom_domain.value.name
      use_subdomain = try(custom_domain.value.use_subdomain, null)
    }
  }


  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key
    content {
      key_vault_key_id          = customer_managed_key.value.key_vault_key_id
      user_assigned_identity_id = try(customer_managed_key.value.user_assigned_identity_id, null)
    }
  }

  dynamic "identity" {
    for_each = var.identity
    content {
      type         = identity.value.type
      identity_ids = identity.value.managed_identities
    }
  }

  dynamic "blob_properties" {
    for_each = var.blob_properties
    content {
      dynamic "cors_rule" {
        for_each = blob_properties.value.cors_rule
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

  dynamic "queue_properties" {
    for_each = var.queue_properties

    content {
      dynamic "cors_rule" {
        for_each = queue_properties.value.cors_rule

        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = queue_properties.value.logging
        content {
          delete                = logging.value.delete
          read                  = logging.value.read
          write                 = logging.value.write
          version               = logging.value.version
          retention_policy_days = try(logging.value.retention_policy_days, 7)
        }
      }

      dynamic "minute_metrics" {
        for_each = queue_properties.value.minute_metrics

        content {
          enabled               = minute_metrics.value.enabled
          version               = minute_metrics.value.version
          include_apis          = try(minute_metrics.value.include_apis, null)
          retention_policy_days = try(minute_metrics.value.retention_policy_days, 7)
        }
      }

      dynamic "hour_metrics" {
        for_each = queue_properties.value.hour_metrics

        content {
          enabled               = hour_metrics.value.enabled
          version               = hour_metrics.value.version
          include_apis          = try(hour_metrics.value.include_apis, null)
          retention_policy_days = try(hour_metrics.value.retention_policy_days, 7)
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = var.static_website

    content {
      index_document     = try(static_website.value.index_document, null)
      error_404_document = try(static_website.value.error_404_document, null)
    }
  }

  dynamic "share_properties" {
    for_each = var.share_properties

    content {
      dynamic "cors_rule" {
        for_each = share_properties.value.cors_rule

        content {
          allowed_headers    = cors_rule.value.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = share_properties.value.retention_policy

        content {
          days = retention_policy.value.days
        }
      }

      dynamic "smb" {
        for_each = share_properties.value.smb
        content {
          versions                        = smb.value.versions
          authentication_types            = smb.value.authentication_types
          kerberos_ticket_encryption_type = smb.value.kerberos_ticket_encryption_type
          channel_encryption_type         = smb.value.channel_encryption_type
          multichannel_enabled            = smb.value.multichannel_enabled
        }
      }
    }
  }

  # azure-cis-3.7.x-storage-default-network-access-rule-set-to-deny
  # azure-cis-3.8.x-storage-trusted-microsoft-services-is-enabled
  dynamic "network_rules" {
    for_each = var.network_rules
    content {
      bypass                     = try(network_rules.value.bypass, [])
      default_action             = try(network_rules.value.default_action, "Deny")
      ip_rules                   = try(network_rules.value.ip_rules, [])
      virtual_network_subnet_ids = try(network_rules.value.subnets, null)

      dynamic "private_link_access" {
        for_each = network_rules.value.private_link_access
        content {
          endpoint_resource_id = try(private_link_access.value.endpoint_resource_id, null)
          endpoint_tenant_id   = try(private_link_access.value.endpoint_tenant_id, null)
        }
      }
    }
  }

  large_file_share_enabled = var.large_file_share_enabled

  dynamic "azure_files_authentication" {
    for_each = var.azure_files_authentication

    content {
      directory_type = azure_files_authentication.value.directory_type

      dynamic "active_directory" {
        for_each = azure_files_authentication.value.active_directory

        content {
          storage_sid         = active_directory.value.storage_sid
          domain_name         = active_directory.value.domain_name
          domain_sid          = active_directory.value.domain_sid
          domain_guid         = active_directory.value.domain_guid
          forest_name         = active_directory.value.forest_name
          netbios_domain_name = active_directory.value.netbios_domain_name
        }
      }
    }
  }

  dynamic "routing" {
    for_each = var.routing

    content {
      publish_internet_endpoints  = try(routing.value.publish_internet_endpoints, false)
      publish_microsoft_endpoints = try(routing.value.publish_microsoft_endpoints, false)
      choice                      = try(routing.value.choice, "MicrosoftRouting")
    }
  }

  lifecycle {
    ignore_changes = [
      location, resource_group_name
    ]
  }

  tags = var.tags
}

# azure-cis-3.x-storage-advanced-threat-protection-is-enabled
resource "azurerm_advanced_threat_protection" "advanced_threat_protection" {
  count              = var.enable_advanced_threat_protection ? 1 : 0
  target_resource_id = azurerm_storage_account.storage_account.id
  enabled            = var.enable_advanced_threat_protection
}

resource "azurerm_role_assignment" "azurerm_role_assignment_developer_blob_data_contributor" {
  count                = var.systemaccess_developer_group_id == "00000000-0000-0000-0000-000000000000" ? 0 : 1
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.systemaccess_developer_group_id
}

resource "azurerm_role_assignment" "azurerm_role_assignment_developer_blob_data_reader" {
  count                = var.systemaccess_developer_group_id == "00000000-0000-0000-0000-000000000000" ? 0 : 1
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.systemaccess_developer_group_id
}

resource "azurerm_role_assignment" "azurerm_role_assignment_developer_queue_data_reader" {
  count                = var.systemaccess_developer_group_id == "00000000-0000-0000-0000-000000000000" ? 0 : 1
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Queue Data Reader"
  principal_id         = var.systemaccess_developer_group_id
}

resource "azurerm_role_assignment" "azurerm_role_assignment_developer_reader_and_data_access" {
  count                = var.systemaccess_developer_group_id == "00000000-0000-0000-0000-000000000000" ? 0 : 1
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = "Reader and Data Access"
  principal_id         = var.systemaccess_developer_group_id
}

# resource "azurerm_key_vault_secret" "primary_access_key" {
#   count        = var.azurerm_key_vault == null ? 0 : 1
#   name         = "${azurerm_storage_account.storage_account.name}-primary-access-key" # Note: "name" may only contain alphanumeric characters and dashes.
#   value        = azurerm_storage_account.storage_account.primary_access_key
#   key_vault_id = var.azurerm_key_vault.id
# }

# resource "azurerm_key_vault_secret" "secondary_access_key" {
#   count        = var.azurerm_key_vault == null ? 0 : 1
#   name         = "${azurerm_storage_account.storage_account.name}-secondary-access-key" # Note: "name" may only contain alphanumeric characters and dashes.
#   value        = azurerm_storage_account.storage_account.secondary_access_key
#   key_vault_id = var.azurerm_key_vault.id
# }

# resource "azurerm_key_vault_secret" "primary_connection_string" {
#   count        = var.azurerm_key_vault == null ? 0 : 1
#   name         = "${azurerm_storage_account.storage_account.name}-primary-connection-string" # Note: "name" may only contain alphanumeric characters and dashes.
#   value        = azurerm_storage_account.storage_account.primary_connection_string
#   key_vault_id = var.azurerm_key_vault.id
# }

# resource "azurerm_key_vault_secret" "secondary_connection_string" {
#   count        = var.azurerm_key_vault == null ? 0 : 1
#   name         = "${azurerm_storage_account.storage_account.name}-secondary-connection-string" # Note: "name" may only contain alphanumeric characters and dashes.
#   value        = azurerm_storage_account.storage_account.secondary_connection_string
#   key_vault_id = var.azurerm_key_vault.id
# }
