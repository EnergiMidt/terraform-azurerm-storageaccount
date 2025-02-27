variable "environment" {
  description = "(Required) The name of the environment."
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

# This `name` variable is replaced by the use of `system_name` and `environment` variables.
# variable "name" {
#   description = "(Required) The name which should be used for this resource. Changing this forces a new resource to be created."
#   type        = string
# }

variable "system_name" {
  description = "(Required) The systen name which should be used for this resource. Changing this forces a new resource to be created."
  type        = string
}

variable "override_name" {
  description = "(Optional) Override the name of the resource. Under normal circumstances, it should not be used."
  default     = null
  type        = string
}

variable "override_location" {
  description = "(Optional) Override the location of the resource. Under normal circumstances, it should not be used."
  default     = null
  type        = string
}

variable "resource_group" {
  description = "(Required) The resource group where this resource should exist."
  type        = any
}

# This `resource_group_name` variable is replaced by the use of `resource_group` variable.
# variable "resource_group_name" {
#   description = "(Required) The name of the resource group where the resource should exist. Changing this forces a new resource to be created."
#   type        = string
# }

# This `location` variable is replaced by the use of `resource_group` variable.
# variable "location" {
#   description = "(Required) The location where the resource should exist. Changing this forces a new resource to be created."
#   type        = string
# }

variable "account_kind" {
  default     = "StorageV2"
  description = "(Optional) Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` or `StorageV2`. Changing this forces a new resource to be created. Defaults to StorageV2."
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
    error_message = "Valid options are `Standard` and `Premium`."
  }
}

variable "account_replication_type" {
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` or `RAGZRS`. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa."
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
    error_message = "Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` or `RAGZRS`."
  }
}

variable "cross_tenant_replication_enabled" {
  description = "(Optional) Should cross Tenant replication be enabled? Defaults to `true`."
  type        = bool
  default     = true
}

variable "access_tier" {
  description = "(Optional) Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`. Defaults to `Hot`."
  type        = string
  default     = "Hot"
  validation {
    condition     = can(regex("^(Hot|Cool)$", var.access_tier))
    error_message = "Valid options are `Hot` and `Cool`."
  }
}

variable "edge_zone" {
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created."
  type        = string
  default     = null
}

variable "enable_https_traffic_only" {
  # azure-cis-3.1-storage-secure-transfer-required-is-enabled
  description = "(Optional) Boolean flag which forces HTTPS if enabled, see [here](https://docs.microsoft.com/azure/storage/storage-require-secure-transfer/) for more information. Defaults to `true`."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "(Optional) The minimum supported TLS version for the storage account. Possible values are `TLS1_0`, `TLS1_1`, and `TLS1_2`. Defaults to `TLS1_2` for new storage accounts."
  type        = string
  default     = "TLS1_2"
  validation {
    condition     = can(regex("^(TLS1_0|TLS1_1|TLS1_2)$", var.min_tls_version))
    error_message = "Possible values are `TLS1_0`, `TLS1_1`, and `TLS1_2`."
  }
}

variable "allow_nested_items_to_be_public" {
  description = "(Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to `true`."
  type        = bool
  default     = true
}

variable "shared_access_key_enabled" {
  description = "(Optional) Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is `true`."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether the public network access is enabled? Defaults to `true`."
  type        = bool
  default     = true
}

variable "default_to_oauth_authentication" {
  description = "(Optional) Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. The default value is `false`."
  type        = bool
  default     = false
}

variable "is_hns_enabled" {
  description = "(Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 ([see here for more information](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-quickstart-create-account/)). Changing this forces a new resource to be created."
  type        = bool
  default     = null
}

variable "sftp_enabled" {
  description = "(Optional) Enable SFTP for the storage account. Defaults to `false`."
  type        = bool
  default     = false
}

variable "nfsv3_enabled" {
  description = "(Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to `false`."
  type        = bool
  default     = false
}

variable "custom_domain" {
  description = "(Optional) A `custom_domain` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)."
  type        = any
  default     = []
}

variable "customer_managed_key" {
  description = "(Optional) A `customer_managed_key` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)."
  type        = any
  default     = []
}

variable "identity" {
  description = "(Optional) An `identity` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)."
  type        = any
  default     = []
}

variable "blob_properties" {
  description = "(Optional) A `blob_properties` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)."
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
  default = []
}

variable "queue_properties" {
  description = "(Optional) A `queue_properties` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)."
  type = list(
    object(
      {
        cors_rule = optional(list(
          object(
            {
              allowed_headers    = list(string)
              allowed_methods    = list(string)
              allowed_origins    = list(string)
              exposed_headers    = list(string)
              max_age_in_seconds = number
            }
          )
        ))
        logging = optional(list(
          object(
            {
              delete                = bool
              read                  = bool
              write                 = bool
              version               = string
              retention_policy_days = optional(number)
            }
          )
        ))
        hour_metrics = optional(list(
          object(
            {
              enabled               = bool
              version               = string
              include_apis          = optional(bool)
              retention_policy_days = optional(number)
            }
          )
        ))
        minute_metrics = optional(list(
          object(
            {
              enabled               = bool
              version               = string
              include_apis          = optional(bool)
              retention_policy_days = optional(number)
            }
          )
        ))
      }
    )
  )
  default = [{
    cors_rule = []
    logging = [{
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 90
    }]
    hour_metrics = [{
      enabled               = true
      include_apis          = true
      version               = "1.0"
      retention_policy_days = 90
    }]
    minute_metrics = [{
      enabled               = true
      include_apis          = true
      version               = "1.0"
      retention_policy_days = 90
    }]
  }]
}

variable "static_website" {
  description = "(Optional) A `static_website` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)."
  type        = any
  default     = []
}

variable "share_properties" {
  description = "(Optional) A `share_properties` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)."
  type        = any
  default     = []
}

variable "network_rules" {
  description = "(Optional) A `network_rules` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)."
  type = list(object({
    default_action             = string
    bypass                     = optional(list(string))
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
    private_link_access = optional(list(
      object({
        endpoint_resource_id = string
        endpoint_tenant_id   = optional(string)
      })
    ))
  }))
  # azure-cis-3.7.x-storage-default-network-access-rule-set-to-deny
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules
  # https://aquasecurity.github.io/tfsec/v1.28.0/checks/azure/storage/default-action-deny/
  # tfsec:ignore:azure-storage-default-action-deny
  default = [{
    default_action             = "Allow"
    bypass                     = ["AzureServices"]
    ip_rules                   = []
    virtual_network_subnet_ids = []
    private_link_access        = []
  }]
}

variable "large_file_share_enabled" {
  description = "(Optional) Is Large File Share Enabled?"
  type        = bool
  default     = false
}

variable "azure_files_authentication" {
  description = "(Optional) An `azure_files_authentication` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)."
  type        = any
  default     = []
}

variable "routing" {
  description = "(Optional) A `routing` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)."
  type        = any
  default     = []
}

variable "queue_encryption_key_type" {
  description = "(Optional) The encryption type of the queue service. Possible values are `Service` and `Account`. Changing this forces a new resource to be created. Default value is `Service`."
  type        = string
  default     = "Service"
  validation {
    condition     = can(regex("^(Service|Account)$", var.queue_encryption_key_type))
    error_message = "Possible values are `Service` and `Account`."
  }
}

variable "table_encryption_key_type" {
  description = "(Optional) The encryption type of the table service. Possible values are `Service` and `Account`. Changing this forces a new resource to be created. Default value is `Service`."
  type        = string
  default     = "Service"
  validation {
    condition     = can(regex("^(Service|Account)$", var.table_encryption_key_type))
    error_message = "Possible values are `Service` and `Account`."
  }
}

variable "infrastructure_encryption_enabled" {
  description = "(Optional) Is infrastructure encryption enabled? Changing this forces a new resource to be created. Defaults to `false`."
  type        = bool
  default     = false
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "enable_advanced_threat_protection" {
  # azure-cis-3.x-storage-advanced-threat-protection-is-enabled
  description = "(Optional) Should costly Advanced Threat Protection be enabled on this resource? Enable only in production environment is highly recommended."
  type        = bool
  default     = false
}

variable "systemaccess_developer_group_id" {
  description = "The object id of an Azure AD group. Gets read access to the Storage Account. To grant additional access, use `azurerm_role_assignment`."
  default     = "00000000-0000-0000-0000-000000000000"
  type        = string
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$", var.systemaccess_developer_group_id))
    error_message = "The systemaccess_developer_group_id value must be a valid globally unique identifier (GUID)."
  }
}

# variable "azurerm_key_vault" {
#   description = "(Optional) The Azure Key Vault instance to store secrets."
#   type        = any
#   default     = null
# }
