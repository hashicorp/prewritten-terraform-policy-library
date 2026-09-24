# Copyright IBM Corp. 2026

# Ensure IAM instance roles are used for AWS resource access from instances

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "iam-instance-role-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_instance" "require_iam_instance_profile" {

  locals {
    iam_instance_profile = core::try(attrs.iam_instance_profile, null)
  }

  enforcement_level = input.iam-instance-role-enforcement-level
  enforce {
    condition     = local.iam_instance_profile != null && local.iam_instance_profile != ""
    error_message = "EC2 instances must specify a non-empty IAM instance profile. Set iam_instance_profile to an IAM instance profile name."
  }
}
