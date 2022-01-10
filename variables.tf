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

variable "ad_password_ssm_parameter_name" {
  type        = string
  description = "Name of SSM parameter to store the AD administrator password"
  default = "/ad/password"
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
