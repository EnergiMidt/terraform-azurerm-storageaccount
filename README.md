# [terraform-azurerm-storageaccount][1]

Manages an Azure Storage Account.

## Getting Started

- Format and validate Terraform code before commit.

```shell
terraform init -upgrade \
    && terraform init -reconfigure -upgrade \
    && terraform fmt -recursive . \
    && terraform fmt -check \
    && terraform validate .
```

- Always fetch latest changes from upstream and rebase from it. Terraform documentation will always be updated with GitHub Actions. See also [.github/workflows/terraform.yml](.github/workflows/terraform.yml) GitHub Actions workflow.

```shell
git fetch --all --tags --prune --prune-tags \
  && git pull --rebase --all --prune --tags
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_advanced_threat_protection.advanced_threat_protection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/advanced_threat_protection) | resource |
| [azurerm_key_vault_secret.primary_access_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.secondary_access_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.secondary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_role_assignment.azurerm_role_assignment_developer_blob_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.azurerm_role_assignment_developer_blob_data_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.azurerm_role_assignment_developer_queue_data_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.azurerm_role_assignment_developer_reader_and_data_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_network_rules.network_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | (Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. Defaults to StorageV2. | `string` | `"StorageV2"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | (Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa. | `string` | n/a | yes |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | (Optional) Defines the Tier to use for this storage account. Valid options are `Standard` and `Premium`. For `BlockBlobStorage` and `FileStorage` accounts only `Premium` is valid. Changing this forces a new resource to be created. | `string` | `"Standard"` | no |
| <a name="input_azurerm_key_vault"></a> [azurerm\_key\_vault](#input\_azurerm\_key\_vault) | (Optional) The Azure Key Vault instance to store secrets. | `any` | `null` | no |
| <a name="input_blob_properties"></a> [blob\_properties](#input\_blob\_properties) | (Optional) The properties of a storage account's blob service. | <pre>list(<br>    object(<br>      {<br>        cors_rule = list(<br>          object(<br>            {<br>              allowed_headers    = optional(list(string))<br>              allowed_methods    = optional(list(string))<br>              allowed_origins    = optional(list(string))<br>              exposed_headers    = optional(list(string))<br>              max_age_in_seconds = optional(number)<br>            }<br>          )<br>        )<br>        delete_retention_policy = list(<br>          object(<br>            {<br>              days = optional(number)<br>            }<br>          )<br>        )<br>        versioning_enabled       = optional(bool)<br>        change_feed_enabled      = optional(bool)<br>        default_service_version  = optional(string)<br>        last_access_time_enabled = optional(bool)<br>        container_delete_retention_policy = list(<br>          object(<br>            {<br>              days = optional(number)<br>            }<br>          )<br>        )<br>      }<br>    )<br>  )</pre> | `[]` | no |
| <a name="input_enable_advanced_threat_protection"></a> [enable\_advanced\_threat\_protection](#input\_enable\_advanced\_threat\_protection) | (Optional) Should costly Advanced Threat Protection be enabled on this resource? Enable only in production environment is highly recommended. | `bool` | `false` | no |
| <a name="input_enable_https_traffic_only"></a> [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | (Optional) Is traffic only allowed via HTTPS? See https://docs.microsoft.com/en-us/azure/storage/common/storage-require-secure-transfer for more information. | `bool` | `true` | no |
| <a name="input_enable_storage_queue_logging"></a> [enable\_storage\_queue\_logging](#input\_enable\_storage\_queue\_logging) | (Optional) Is storage logging is enabled for queue service? | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The name of the environment. | `string` | `null` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | (Optional) The minimum supported TLS version for the storage account. Possible values are `TLS1_0`, `TLS1_1`, and `TLS1_2`. Defaults to `TLS1_2` for new storage accounts. | `string` | `"TLS1_2"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this resource. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_network_rules_bypass"></a> [network\_rules\_bypass](#input\_network\_rules\_bypass) | (Optional) Specifies whether traffic is bypassed for AzureServices/Logging/Metrics. Valid options are any combination of Logging, Metrics, AzureServices, or None. | `list(string)` | <pre>[<br>  "AzureServices"<br>]</pre> | no |
| <a name="input_network_rules_default_action"></a> [network\_rules\_default\_action](#input\_network\_rules\_default\_action) | (Optional) Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow. | `string` | `"Allow"` | no |
| <a name="input_network_rules_ip_rules"></a> [network\_rules\_ip\_rules](#input\_network\_rules\_ip\_rules) | (Optional) List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. Private IP address ranges (as defined in RFC 1918) are not allowed. | `list(string)` | `[]` | no |
| <a name="input_network_rules_virtual_network_subnet_ids"></a> [network\_rules\_virtual\_network\_subnet\_ids](#input\_network\_rules\_virtual\_network\_subnet\_ids) | (Optional) A list of virtual network subnet ids to to secure the storage account. | `list(string)` | `[]` | no |
| <a name="input_override_location"></a> [override\_location](#input\_override\_location) | (Optional) Override the location of the resource. Under normal circumstances, it should not be used. | `string` | `null` | no |
| <a name="input_override_name"></a> [override\_name](#input\_override\_name) | (Optional) Override the name of the resource. Under normal circumstances, it should not be used. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The resource group where this resource should exist. | `any` | n/a | yes |
| <a name="input_static_website_enabled"></a> [static\_website\_enabled](#input\_static\_website\_enabled) | Enable static website. | `string` | `false` | no |
| <a name="input_systemaccess_developer_group_id"></a> [systemaccess\_developer\_group\_id](#input\_systemaccess\_developer\_group\_id) | The object id of an Azure AD group. Gets read access to the Storage Account. To grant additional access, use `azurerm_role_assignment`. | `string` | `"00000000-0000-0000-0000-000000000000"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_storage_account"></a> [azurerm\_storage\_account](#output\_azurerm\_storage\_account) | The Azure Storage Account resource. |
<!-- END_TF_DOCS -->

[1]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
