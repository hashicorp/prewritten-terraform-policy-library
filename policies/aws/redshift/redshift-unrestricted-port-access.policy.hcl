# Copyright IBM Corp. 2026

# Redshift.15 - Redshift security groups should allow ingress on the cluster port only from restricted origins.
# This control checks whether a security group associated with an Amazon Redshift cluster has ingress rules that permit access to the cluster port from the internet (0.0.0.0/0 or ::/0). The control fails if the security group ingress rules permit access to the cluster port from the internet.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "redshift-unrestricted-port-access-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_redshift_cluster" "unrestricted-port-access" {
  enforcement_level = input.redshift-unrestricted-port-access-enforcement-level
  filter            = core::try(core::length(attrs.vpc_security_group_ids) > 0, false)

  connected "aws_vpc_security_group_ingress_rule" {
    connection {
      subject_list = "vpc_security_group_ids"
      connected    = "security_group_id"
    }

    enforce {
      condition = !(
        (
          core::try(connected.aws_vpc_security_group_ingress_rule.ip_protocol, "-1") == "-1" ||
          (
            core::try(connected.aws_vpc_security_group_ingress_rule.from_port, 1115) <= core::try(attrs.port, 5439) &&
            core::try(connected.aws_vpc_security_group_ingress_rule.to_port, 65535) >= core::try(attrs.port, 5439)
          )
        ) &&
        (
          core::try(connected.aws_vpc_security_group_ingress_rule.cidr_ipv4, "") == "0.0.0.0/0" ||
          core::try(connected.aws_vpc_security_group_ingress_rule.cidr_ipv6, "") == "::/0"
        )
      )
      error_message = "Redshift cluster has unrestricted access to its port. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshift-controls.html#redshift-15 for more details."
    }
  }
}
