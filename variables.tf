variable "environment" {
  description = "(Required) The name of the environment."
  default     = null
  type        = string
  validation {
    condition = contains([
      "dev",
      "test",
      "prod",
    ], var.environment)
    error_message = "Possible values are dev, test, and prod."
  }
}

variable "storage_name" {
  type = string
}

variable "override_name" {
  description = "(Optional) Override the name of the resource. Under normal circumstances, it should not be used."
  default     = ""
  type        = string
}

variable "resource_group" {
  description = "(Required) The resource group in which to create the Storage Account component."
  type        = any
}

variable "account_replication_type" {
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa."
  type        = string
  validation {
    condition = contains([
      "LRS",
      "GRS",
      "RAGRS",
      "ZRS",
      "GZRS",
      "RAGZRS"
    ], var.account_replication_type)
    error_message = "The `account_replication_type` variable must be one of `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` or `RAGZRS`."
  }
}

variable "account_kind" {
  default     = "StorageV2"
  description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. Defaults to StorageV2."
  type        = string
  validation {
    condition = contains([
      "BlobStorage",
      "BlockBlobStorage",
      "FileStorage",
      "Storage",
      "StorageV2"
    ], var.account_kind)
    error_message = "The `account_kind` variable must be one of `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` or `StorageV2`."
  }
}

variable "account_tier" {
  description = "(Optional) Defines the Tier to use for this storage account. Valid options are `Standard` and `Premium`. For `BlockBlobStorage` and `FileStorage` accounts only `Premium` is valid. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard"
  validation {
    condition     = can(regex("^(Standard|Premium)$", var.account_tier))
    error_message = "The `account_tier` variable must be one of `Standard` or `Premium`."
  }
}

variable "min_tls_version" {
  description = " (Optional) The minimum supported TLS version for the storage account. Possible values are `TLS1_0`, `TLS1_1`, and `TLS1_2`. Defaults to `TLS1_2` for new storage accounts."
  type        = string
  default     = "TLS1_2"
  validation {
    condition     = can(regex("^(TLS1_0|TLS1_1|TLS1_2)$", var.min_tls_version))
    error_message = "The `account_kind` variable must be one of `TLS1_0`, `TLS1_1` or `TLS1_2`."
  }
}

variable "enable_https_traffic_only" {
  # azure-cis-3.1-storage-secure-transfer-required-is-enabled
  description = "(Optional) Is traffic only allowed via HTTPS? See https://docs.microsoft.com/en-us/azure/storage/common/storage-require-secure-transfer for more information."
  default     = true
  type        = bool
}

variable "enable_storage_queue_logging" {
  # azure-cis-3.3-storage-queue-logging-is-enable
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/4401#issuecomment-579400404
  description = "(Optional) Is storage logging is enabled for queue service?"
  default     = true
  type        = bool
}

variable "enable_advanced_threat_protection" {
  # azure-cis-3.x-storage-advanced-threat-protection-is-enabled
  description = "(Optional) Should costly Advanced Threat Protection be enabled on this resource? Enable only in production environment is highly recommended."
  type        = bool
  default     = false
}

variable "network_rules_default_action" {
  # azure-cis-3.7.x-storage-default-network-access-rule-set-to-deny
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules
  # https://aquasecurity.github.io/tfsec/v1.28.0/checks/azure/storage/default-action-deny/
  # tfsec:ignore:azure-storage-default-action-deny
  description = "(Optional) Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow."
  default     = "Allow" # Use Allow as our custom default value as the recommmended Deny value by Center for Internet Security (CIS) is too restrictive.
  type        = string
}

variable "network_rules_ip_rules" {
  # azure-cis-3.7.x-storage-default-network-access-rule-set-to-deny
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules
  description = "(Optional) List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. Private IP address ranges (as defined in RFC 1918) are not allowed."
  default     = [] # Ignored if network_rules_default_action has Allow as value.
  type        = list(string)
}

variable "network_rules_virtual_network_subnet_ids" {
  # azure-cis-3.7.x-storage-default-network-access-rule-set-to-deny
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules
  description = "(Optional) A list of virtual network subnet ids to to secure the storage account."
  default     = [] # Ignored if network_rules_default_action has Allow as value.
  type        = list(string)
}

variable "network_rules_bypass" {
  # azure-cis-3.7.x-storage-default-network-access-rule-set-to-deny
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules
  description = "(Optional) Specifies whether traffic is bypassed for AzureServices/Logging/Metrics. Valid options are any combination of Logging, Metrics, AzureServices, or None."
  default     = ["AzureServices"] # Ignored if network_rules_default_action has Allow as value.
  type        = list(string)
}

variable "override_location" {
  default = ""
  type    = string
}

variable "systemaccess_developer_group_id" {
  description = "The object id of the Azure AD group systemaccess-<system>-developers. Gets read access to the Storage Account. To grant additional access, use azurerm_role_assignment."
  default     = "00000000-0000-0000-0000-000000000000"
  type        = string
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$", var.systemaccess_developer_group_id))
    error_message = "The systemaccess_developer_group_id value must be a valid globally unique identifier (GUID)."
  }
}

variable "static_website_enabled" {
  description = "Enable static website."
  type        = string
  default     = false
}

variable "blob_properties" {
  default     = []
  description = "(Optional) The properties of a storage account's blob service."
  type = list(
    object(
      {
        cors_rule = list(
          object(
            {
              allowed_headers    = optional(list(string))
              allowed_methods    = optional(list(string))
              allowed_origins    = optional(list(string))
              exposed_headers    = optional(list(string))
              max_age_in_seconds = optional(number)
            }
          )
        )
        delete_retention_policy = list(
          object(
            {
              days = optional(number)
            }
          )
        )
        versioning_enabled       = optional(bool)
        change_feed_enabled      = optional(bool)
        default_service_version  = optional(string)
        last_access_time_enabled = optional(bool)
        container_delete_retention_policy = list(
          object(
            {
              days = optional(number)
            }
          )
        )
      }
    )
  )
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
  type        = map(string)
}

variable "azurerm_key_vault" {
  description = "(Optional) The Azure Key Vault instance to store secrets."
  default     = null
  type        = any
}
