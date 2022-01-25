variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "ad_name" {
  type        = string
  description = "AD name (FQDN), in the format `directory.example.com`"
}

variable "ad_log_retention_in_days" {
  type        = number
  description = "AD log retention in days"
  default     = 30
}

variable "ad_ssm_prefix" {
  type        = string
  description = "SSM prefix for AD"
  default     = "/ad"
}

variable "ad_ssm_parameter_name_domain" {
  type        = string
  description = "Name of SSM parameter to store the AD domain name"
  default     = "/domain"
}

variable "ad_ssm_parameter_name_username" {
  type        = string
  description = "Name of SSM parameter to store the AD administrator password"
  default     = "/username"
}

variable "ad_ssm_parameter_name_password" {
  type        = string
  description = "Name of SSM parameter to store the AD administrator password"
  default     = "/password"
}

variable "ad_ssm_parameter_name_dns_servers" {
  type        = string
  description = "Name of SSM parameter to store the AD domain controller IPs (DNS servers)"
  default     = "/dns-servers"
}

variable "kms_key_deletion_window_in_days" {
  type        = number
  description = "KMS key deletion window in days"
  default     = 30
}

variable "kms_key_enable_rotation" {
  type        = bool
  description = "Enable KMS key rotation?"
  default     = true
}

variable "kms_key_name" {
  type        = string
  description = "KMS key name, appended to `alias/`"
  default     = "fsx-key"
}

variable "fsx_file_system_name" {
  type        = string
  description = "Name of the FSx Windows file system"
  default     = "file-system"
}

variable "fsx_ssm_prefix" {
  type        = string
  description = "SSM parameters prefix for FSx"
  default     = "/fsx"
}

variable "fsx_ssm_parameter_name_ip_address" {
  type        = string
  description = "Name of SSM parameter to store the file system IP address"
  default     = "/ip-address"
}

variable "fsx_deployment_type" {
  type        = string
  description = "FSx deployment type"
  default     = "SINGLE_AZ_2"
  validation {
    condition     = can(regex("^SINGLE_AZ_1|SINGLE_AZ_2|MULTI_AZ_1$", var.fsx_deployment_type))
    error_message = "Must be one of `SINGLE_AZ_1` or `SINGLE_AZ_2` or `MULTI_AZ_1`."
  }
}

variable "fsx_storage_type" {
  type        = string
  description = "FSx storage type"
  default     = "SSD"
  validation {
    condition     = can(regex("^SSD|HDD$", var.fsx_storage_type))
    error_message = "Must be one of `SSD` or `HDD`."
  }
}

variable "fsx_skip_final_backup" {
  type        = bool
  description = "Skip final FSx backup?"
  default     = true
}

variable "fsx_storage_capacity" {
  type        = number
  description = "FSx Storage capacity"
  default     = 32
}

variable "fsx_throughput_capacity" {
  type        = number
  description = "FSx throughput capacity"
  default     = 8
}
