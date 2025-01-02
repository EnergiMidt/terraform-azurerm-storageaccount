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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.14.0, < 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_advanced_threat_protection.advanced_threat_protection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/advanced_threat_protection) | resource |
| [azurerm_role_assignment.azurerm_role_assignment_developer_blob_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.azurerm_role_assignment_developer_blob_data_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.azurerm_role_assignment_developer_queue_data_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.azurerm_role_assignment_developer_reader_and_data_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | (Optional) Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`. Defaults to `Hot`. | `string` | `"Hot"` | no |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | (Optional) Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` or `StorageV2`. Changing this forces a new resource to be created. Defaults to StorageV2. | `string` | `"StorageV2"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | (Required) Defines the type of replication to use for this storage account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` or `RAGZRS`. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa. | `string` | n/a | yes |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | (Optional) Defines the Tier to use for this storage account. Valid options are `Standard` and `Premium`. For `BlockBlobStorage` and `FileStorage` accounts only `Premium` is valid. Changing this forces a new resource to be created. | `string` | `"Standard"` | no |
| <a name="input_allow_nested_items_to_be_public"></a> [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public) | (Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_azure_files_authentication"></a> [azure\_files\_authentication](#input\_azure\_files\_authentication) | (Optional) An `azure_files_authentication` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account). | `any` | `[]` | no |
| <a name="input_blob_properties"></a> [blob\_properties](#input\_blob\_properties) | (Optional) A `blob_properties` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account). | <pre>list(<br/>    object(<br/>      {<br/>        cors_rule = list(<br/>          object(<br/>            {<br/>              allowed_headers    = optional(list(string))<br/>              allowed_methods    = optional(list(string))<br/>              allowed_origins    = optional(list(string))<br/>              exposed_headers    = optional(list(string))<br/>              max_age_in_seconds = optional(number)<br/>            }<br/>          )<br/>        )<br/>        delete_retention_policy = list(<br/>          object(<br/>            {<br/>              days = optional(number)<br/>            }<br/>          )<br/>        )<br/>        versioning_enabled       = optional(bool)<br/>        change_feed_enabled      = optional(bool)<br/>        default_service_version  = optional(string)<br/>        last_access_time_enabled = optional(bool)<br/>        container_delete_retention_policy = list(<br/>          object(<br/>            {<br/>              days = optional(number)<br/>            }<br/>          )<br/>        )<br/>      }<br/>    )<br/>  )</pre> | `[]` | no |
| <a name="input_cross_tenant_replication_enabled"></a> [cross\_tenant\_replication\_enabled](#input\_cross\_tenant\_replication\_enabled) | (Optional) Should cross Tenant replication be enabled? Defaults to `true`. | `bool` | `true` | no |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | (Optional) A `custom_domain` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account). | `any` | `[]` | no |
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | (Optional) A `customer_managed_key` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account). | `any` | `[]` | no |
| <a name="input_default_to_oauth_authentication"></a> [default\_to\_oauth\_authentication](#input\_default\_to\_oauth\_authentication) | (Optional) Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. The default value is `false`. | `bool` | `false` | no |
| <a name="input_edge_zone"></a> [edge\_zone](#input\_edge\_zone) | (Optional) Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created. | `string` | `null` | no |
| <a name="input_enable_advanced_threat_protection"></a> [enable\_advanced\_threat\_protection](#input\_enable\_advanced\_threat\_protection) | (Optional) Should costly Advanced Threat Protection be enabled on this resource? Enable only in production environment is highly recommended. | `bool` | `false` | no |
| <a name="input_enable_https_traffic_only"></a> [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | (Optional) Boolean flag which forces HTTPS if enabled, see [here](https://docs.microsoft.com/azure/storage/storage-require-secure-transfer/) for more information. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The name of the environment. | `string` | n/a | yes |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) An `identity` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account). | `any` | `[]` | no |
| <a name="input_infrastructure_encryption_enabled"></a> [infrastructure\_encryption\_enabled](#input\_infrastructure\_encryption\_enabled) | (Optional) Is infrastructure encryption enabled? Changing this forces a new resource to be created. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_is_hns_enabled"></a> [is\_hns\_enabled](#input\_is\_hns\_enabled) | (Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 ([see here for more information](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-quickstart-create-account/)). Changing this forces a new resource to be created. | `bool` | `null` | no |
| <a name="input_large_file_share_enabled"></a> [large\_file\_share\_enabled](#input\_large\_file\_share\_enabled) | (Optional) Is Large File Share Enabled? | `bool` | `false` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | (Optional) The minimum supported TLS version for the storage account. Possible values are `TLS1_0`, `TLS1_1`, and `TLS1_2`. Defaults to `TLS1_2` for new storage accounts. | `string` | `"TLS1_2"` | no |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | (Optional) A `network_rules` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account). | <pre>list(object({<br/>    default_action             = string<br/>    bypass                     = optional(list(string))<br/>    ip_rules                   = optional(list(string))<br/>    virtual_network_subnet_ids = optional(list(string))<br/>    private_link_access = optional(list(<br/>      object({<br/>        endpoint_resource_id = string<br/>        endpoint_tenant_id   = optional(string)<br/>      })<br/>    ))<br/>  }))</pre> | <pre>[<br/>  {<br/>    "bypass": [<br/>      "AzureServices"<br/>    ],<br/>    "default_action": "Allow",<br/>    "ip_rules": [],<br/>    "private_link_access": [],<br/>    "virtual_network_subnet_ids": []<br/>  }<br/>]</pre> | no |
| <a name="input_nfsv3_enabled"></a> [nfsv3\_enabled](#input\_nfsv3\_enabled) | (Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_override_location"></a> [override\_location](#input\_override\_location) | (Optional) Override the location of the resource. Under normal circumstances, it should not be used. | `string` | `null` | no |
| <a name="input_override_name"></a> [override\_name](#input\_override\_name) | (Optional) Override the name of the resource. Under normal circumstances, it should not be used. | `string` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Whether the public network access is enabled? Defaults to `true`. | `bool` | `true` | no |
| <a name="input_queue_encryption_key_type"></a> [queue\_encryption\_key\_type](#input\_queue\_encryption\_key\_type) | (Optional) The encryption type of the queue service. Possible values are `Service` and `Account`. Changing this forces a new resource to be created. Default value is `Service`. | `string` | `"Service"` | no |
| <a name="input_queue_properties"></a> [queue\_properties](#input\_queue\_properties) | (Optional) A `queue_properties` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account). | <pre>list(<br/>    object(<br/>      {<br/>        cors_rule = optional(list(<br/>          object(<br/>            {<br/>              allowed_headers    = list(string)<br/>              allowed_methods    = list(string)<br/>              allowed_origins    = list(string)<br/>              exposed_headers    = list(string)<br/>              max_age_in_seconds = number<br/>            }<br/>          )<br/>        ))<br/>        logging = optional(list(<br/>          object(<br/>            {<br/>              delete                = bool<br/>              read                  = bool<br/>              write                 = bool<br/>              version               = string<br/>              retention_policy_days = optional(number)<br/>            }<br/>          )<br/>        ))<br/>        hour_metrics = optional(list(<br/>          object(<br/>            {<br/>              enabled               = bool<br/>              version               = string<br/>              include_apis          = optional(bool)<br/>              retention_policy_days = optional(number)<br/>            }<br/>          )<br/>        ))<br/>        minute_metrics = optional(list(<br/>          object(<br/>            {<br/>              enabled               = bool<br/>              version               = string<br/>              include_apis          = optional(bool)<br/>              retention_policy_days = optional(number)<br/>            }<br/>          )<br/>        ))<br/>      }<br/>    )<br/>  )</pre> | <pre>[<br/>  {<br/>    "cors_rule": [],<br/>    "hour_metrics": [<br/>      {<br/>        "enabled": true,<br/>        "include_apis": true,<br/>        "retention_policy_days": 90,<br/>        "version": "1.0"<br/>      }<br/>    ],<br/>    "logging": [<br/>      {<br/>        "delete": true,<br/>        "read": true,<br/>        "retention_policy_days": 90,<br/>        "version": "1.0",<br/>        "write": true<br/>      }<br/>    ],<br/>    "minute_metrics": [<br/>      {<br/>        "enabled": true,<br/>        "include_apis": true,<br/>        "retention_policy_days": 90,<br/>        "version": "1.0"<br/>      }<br/>    ]<br/>  }<br/>]</pre> | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The resource group where this resource should exist. | `any` | n/a | yes |
| <a name="input_routing"></a> [routing](#input\_routing) | (Optional) A `routing` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account). | `any` | `[]` | no |
| <a name="input_share_properties"></a> [share\_properties](#input\_share\_properties) | (Optional) A `share_properties` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account). | `any` | `[]` | no |
| <a name="input_shared_access_key_enabled"></a> [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled) | (Optional) Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is `true`. | `bool` | `true` | no |
| <a name="input_static_website"></a> [static\_website](#input\_static\_website) | (Optional) A `static_website` block as documented [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account). | `any` | `[]` | no |
| <a name="input_system_name"></a> [system\_name](#input\_system\_name) | (Required) The systen name which should be used for this resource. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_systemaccess_developer_group_id"></a> [systemaccess\_developer\_group\_id](#input\_systemaccess\_developer\_group\_id) | The object id of an Azure AD group. Gets read access to the Storage Account. To grant additional access, use `azurerm_role_assignment`. | `string` | `"00000000-0000-0000-0000-000000000000"` | no |
| <a name="input_table_encryption_key_type"></a> [table\_encryption\_key\_type](#input\_table\_encryption\_key\_type) | (Optional) The encryption type of the table service. Possible values are `Service` and `Account`. Changing this forces a new resource to be created. Default value is `Service`. | `string` | `"Service"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_storage_account"></a> [azurerm\_storage\_account](#output\_azurerm\_storage\_account) | The Azure Storage Account resource. |
<!-- END_TF_DOCS -->

[1]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
