data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "random_password" "this" {
  length  = 32
  special = true
}

resource "aws_ssm_parameter" "password" {
  name  = var.ad_password_ssm_parameter_name
  type  = "SecureString"
  value = random_password.this.result
}

resource "aws_directory_service_directory" "this" {
  name     = var.ad_name
  password = random_password.this.result
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = var.subnet_ids
  }

}

resource "aws_cloudwatch_log_group" "ad" {
  name              = "/aws/directoryservice/${aws_directory_service_directory.this.id}"
  retention_in_days = 14
}

data "aws_iam_policy_document" "ad_logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    principals {
      type        = "Service"
      identifiers = ["ds.amazonaws.com"]
    }

    resources = [
      aws_cloudwatch_log_group.ad.arn,
      "${aws_cloudwatch_log_group.ad.arn}:*",
      "${aws_cloudwatch_log_group.ad.arn}:*:*"
    ]

    effect = "Allow"
  }
}

resource "aws_cloudwatch_log_resource_policy" "ad_logs" {
  policy_document = data.aws_iam_policy_document.ad_logs.json
  policy_name     = "ad-log-policy"
}

resource "aws_directory_service_log_subscription" "this" {
  directory_id   = aws_directory_service_directory.this.id
  log_group_name = aws_cloudwatch_log_group.ad.name
}

locals {
  root_arn = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
}

data "aws_iam_policy_document" "fsx_key" {

  statement {
    sid       = "IAMUserPermissions"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = [local.root_arn]
    }
  }

  statement {
    sid = "FSxPermissions"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:CreateGrant",
      "kms:ListAliases"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["fsx.amazonaws.com"]
    }
  }
}

resource "aws_kms_key" "this" {
  description             = "Encryption key for FSx"
  enable_key_rotation     = var.kms_key_enable_rotation
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  policy                  = data.aws_iam_policy_document.fsx_key.json
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.kms_key_name}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_security_group" "fsx" {
  vpc_id = var.vpc_id

  revoke_rules_on_delete = true

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "fsx-sg"
  }

  name = "fsx-sg"

}

locals {
  fsx_subnet_ids = var.fsx_deployment_type == "MULTI_AZ_1" ? var.subnet_ids : [var.subnet_ids[0]]
}

resource "aws_fsx_windows_file_system" "this" {
  deployment_type     = var.fsx_deployment_type
  storage_type        = var.fsx_storage_type
  active_directory_id = aws_directory_service_directory.this.id
  subnet_ids          = local.fsx_subnet_ids
  preferred_subnet_id = local.fsx_subnet_ids[0]
  kms_key_id          = aws_kms_key.this.arn
  security_group_ids  = [aws_security_group.fsx.id]
  storage_capacity    = var.fsx_storage_capacity
  throughput_capacity = var.fsx_throughput_capacity
  skip_final_backup   = var.fsx_skip_final_backup

  tags = {
    Name = var.fsx_file_system_name
  }

}

resource "aws_ssm_parameter" "fsx_ip_address" {
  name  = var.fsx_ip_address_ssm_parameter_name
  type  = "SecureString"
  value = base64encode(aws_fsx_windows_file_system.this.preferred_file_server_ip)
}
