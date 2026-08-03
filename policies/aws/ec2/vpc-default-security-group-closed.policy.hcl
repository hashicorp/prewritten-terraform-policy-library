# Copyright IBM Corp. 2026

# EC2.2 - VPC Default Security Groups Traffic Restriction

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.56.0, < 7.0.0"
    }
  }
}

input "vpc-default-security-group-closed-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_default_security_group" "no_inline_traffic_allowed" {
  enforcement_level = input.vpc-default-security-group-closed-enforcement-level

  enforce {
    condition = core::try(core::length(attrs.ingress), 0) == 0
    error_message = "Default security group must not have any ingress rules defined in the ingress block. Remove all ingress rules from the default security group. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-2 for more details."
  }

  enforce {
    condition = core::try(core::length(attrs.egress), 0) == 0
    error_message = "Default security group must not have any egress rules defined in the egress block. Remove all egress rules from the default security group. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-2 for more details."
  }
}

resource_policy "aws_default_security_group" "no_separate_ingress_rules" {
  enforcement_level = input.vpc-default-security-group-closed-enforcement-level

  connected "aws_vpc_security_group_ingress_rule" {
    max_instances = 0

    connection {
      subject   = "id"
      connected = "security_group_id"
    }
  }
}

resource_policy "aws_default_security_group" "no_separate_egress_rules" {
  enforcement_level = input.vpc-default-security-group-closed-enforcement-level

  connected "aws_vpc_security_group_egress_rule" {
    max_instances = 0

    connection {
      subject   = "id"
      connected = "security_group_id"
    }
  }
}

resource_policy "aws_default_security_group" "no_legacy_rules" {
  enforcement_level = input.vpc-default-security-group-closed-enforcement-level

  connected "aws_security_group_rule" {
    max_instances = 0

    connection {
      subject   = "id"
      connected = "security_group_id"
    }
  }
}
