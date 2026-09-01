# Copyright IBM Corp. 2026

# Redshift security groups should allow ingress on the cluster port only from restricted origins

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

  connected "aws_vpc_security_group_ingress_rule" {
    # each unrolls into one independent connected block per element of
    # vpc_security_group_ids, equivalent to writing a separate connected block
    # for vpc_security_group_ids[0], vpc_security_group_ids[1], etc.
    each "vpc_security_group_ids" {
      connection {
        # attrs.vpc_security_group_ids[each.index] is a Terraform reference edge;
        # the engine follows it to find rules whose security_group_id matches.
        subject = "vpc_security_group_ids[${each.index}]"
        target  = "security_group_id"
      }

      cardinality = {
        min_matches   = 1
        error_message = "Redshift cluster security group at index ${each.index} has no ingress rules defined"
      }

      enforce {
        # self = matched aws_vpc_security_group_ingress_rule
        # attrs.port = the Redshift cluster's port (subject context)
        # Condition is true (pass) when the rule does NOT allow unrestricted
        # access to the cluster port.
        condition = !(
          (core::try(self.ip_protocol, "-1") != "-1"
            ? self.from_port <= attrs.port && self.to_port >= attrs.port
            : true)
          && (core::try(self.cidr_ipv4, "") == "0.0.0.0/0" || core::try(self.cidr_ipv6, "") == "::/0")
        )
        error_message = "Redshift cluster has an ingress rule allowing unrestricted access (0.0.0.0/0 or ::/0) to the cluster port"
      }
    }
  }
}
