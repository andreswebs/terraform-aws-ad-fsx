# terraform-aws-ad-fsx

Deploys Active Directory and FSx for Windows file system.

[//]: # (BEGIN_TF_DOCS)


## Usage

Example:

```hcl
module "fsx" {
  source                         = "github.com/andreswebs/terraform-aws-ad-fsx"
  ad_name                        = var.ad_name
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  ad_password_ssm_parameter_name = var.ad_password_ssm_parameter_name
}
```



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_log_retention_in_days"></a> [ad\_log\_retention\_in\_days](#input\_ad\_log\_retention\_in\_days) | AD log retention in days | `number` | `30` | no |
| <a name="input_ad_name"></a> [ad\_name](#input\_ad\_name) | AD name (FQDN), in the format `directory.example.com` | `string` | n/a | yes |
| <a name="input_ad_ssm_parameter_name_dns_servers"></a> [ad\_ssm\_parameter\_name\_dns\_servers](#input\_ad\_ssm\_parameter\_name\_dns\_servers) | Name of SSM parameter to store the AD domain controller IPs (DNS servers) | `string` | `"/dns-servers"` | no |
| <a name="input_ad_ssm_parameter_name_domain"></a> [ad\_ssm\_parameter\_name\_domain](#input\_ad\_ssm\_parameter\_name\_domain) | Name of SSM parameter to store the AD domain name | `string` | `"/domain"` | no |
| <a name="input_ad_ssm_parameter_name_password"></a> [ad\_ssm\_parameter\_name\_password](#input\_ad\_ssm\_parameter\_name\_password) | Name of SSM parameter to store the AD administrator password | `string` | `"/password"` | no |
| <a name="input_ad_ssm_parameter_name_username"></a> [ad\_ssm\_parameter\_name\_username](#input\_ad\_ssm\_parameter\_name\_username) | Name of SSM parameter to store the AD administrator password | `string` | `"/username"` | no |
| <a name="input_ad_ssm_prefix"></a> [ad\_ssm\_prefix](#input\_ad\_ssm\_prefix) | SSM prefix for AD | `string` | `"/ad"` | no |
| <a name="input_fsx_deployment_type"></a> [fsx\_deployment\_type](#input\_fsx\_deployment\_type) | FSx deployment type | `string` | `"SINGLE_AZ_2"` | no |
| <a name="input_fsx_file_system_name"></a> [fsx\_file\_system\_name](#input\_fsx\_file\_system\_name) | Name of the FSx Windows file system | `string` | `"file-system"` | no |
| <a name="input_fsx_skip_final_backup"></a> [fsx\_skip\_final\_backup](#input\_fsx\_skip\_final\_backup) | Skip final FSx backup? | `bool` | `true` | no |
| <a name="input_fsx_ssm_parameter_name_ip_address"></a> [fsx\_ssm\_parameter\_name\_ip\_address](#input\_fsx\_ssm\_parameter\_name\_ip\_address) | Name of SSM parameter to store the file system IP address | `string` | `"/ip-address"` | no |
| <a name="input_fsx_ssm_prefix"></a> [fsx\_ssm\_prefix](#input\_fsx\_ssm\_prefix) | SSM parameters prefix for FSx | `string` | `"/fsx"` | no |
| <a name="input_fsx_storage_capacity"></a> [fsx\_storage\_capacity](#input\_fsx\_storage\_capacity) | FSx Storage capacity | `number` | `32` | no |
| <a name="input_fsx_storage_type"></a> [fsx\_storage\_type](#input\_fsx\_storage\_type) | FSx storage type | `string` | `"SSD"` | no |
| <a name="input_fsx_throughput_capacity"></a> [fsx\_throughput\_capacity](#input\_fsx\_throughput\_capacity) | FSx throughput capacity | `number` | `8` | no |
| <a name="input_kms_key_deletion_window_in_days"></a> [kms\_key\_deletion\_window\_in\_days](#input\_kms\_key\_deletion\_window\_in\_days) | KMS key deletion window in days | `number` | `30` | no |
| <a name="input_kms_key_enable_rotation"></a> [kms\_key\_enable\_rotation](#input\_kms\_key\_enable\_rotation) | Enable KMS key rotation? | `bool` | `true` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | KMS key name, appended to `alias/` | `string` | `"fsx-key"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Modules

No modules.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_directory"></a> [directory](#output\_directory) | The aws\_directory\_service resource |
| <a name="output_directory_info"></a> [directory\_info](#output\_directory\_info) | Non-sensitive info from the aws\_directory\_service\_directory resource |
| <a name="output_file_system"></a> [file\_system](#output\_file\_system) | The aws\_fsx\_windows\_file\_system resource |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.50.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.50.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ad](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.ad_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_directory_service_directory.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory) | resource |
| [aws_directory_service_log_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_log_subscription) | resource |
| [aws_fsx_windows_file_system.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fsx_windows_file_system) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.fsx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.dns_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.fsx_ip_address](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.username](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ad_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.fsx_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

[//]: # (END_TF_DOCS)

## Authors

**Andre Silva** - [@andreswebs](https://github.com/andreswebs)

## License

This project is licensed under the [Unlicense](UNLICENSE.md).
