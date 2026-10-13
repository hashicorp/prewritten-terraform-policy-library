# Copyright IBM Corp. 2026

# VPC default security groups should not allow inbound or outbound traffic

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.56.0, < 7.0.0"
    }
  }
}

input "vpc-default-security-group-closed-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_default_security_group" "no_traffic_allowed" {
  enforcement_level = input.vpc-default-security-group-closed-enforcement-level

  # Inline block rules (ingress/egress attributes on the resource itself)
  enforce {
    condition     = core::try(core::length(attrs.ingress), 0) == 0
    error_message = "Default security group must not have any ingress rules defined in the ingress block. Remove all ingress rules from the default security group"
  }

  enforce {
    condition     = core::try(core::length(attrs.egress), 0) == 0
    error_message = "Default security group must not have any egress rules defined in the egress block. Remove all egress rules from the default security group"
  }

  # reverse=true: the rule resources declare security_group_id pointing at this
  # SG. Assert that no such rules exist (max_matches = 0).
  connected "aws_vpc_security_group_ingress_rule" {
    connection {
      reverse = true
      subject = "security_group_id"
      target  = "id"
    }

    cardinality = {
      max_matches   = 0
      error_message = "Default security group must not have any separate aws_vpc_security_group_ingress_rule resources. Remove all ingress rules"
    }
  }

  connected "aws_vpc_security_group_egress_rule" {
    connection {
      reverse = true
      subject = "security_group_id"
      target  = "id"
    }

    cardinality = {
      max_matches   = 0
      error_message = "Default security group must not have any separate aws_vpc_security_group_egress_rule resources. Remove all egress rules"
    }
  }

  connected "aws_security_group_rule" {
    connection {
      reverse = true
      subject = "security_group_id"
      target  = "id"
    }

    cardinality = {
      max_matches   = 0
      error_message = "Default security group must not have any aws_security_group_rule resources. Remove all security group rules"
    }
  }
}
