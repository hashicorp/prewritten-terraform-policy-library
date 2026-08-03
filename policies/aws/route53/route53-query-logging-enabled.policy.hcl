# Copyright IBM Corp. 2026

# Route53.2: Route 53 public hosted zones should log DNS queries

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "route53-query-logging-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_route53_zone" "dns_query_logging_enabled" {
  enforcement_level = input.route53-query-logging-enabled-enforcement-level
  # Only check public hosted zones (private zones have vpc blocks)
  filter = core::try(core::length(attrs.vpc), 0) == 0

  connected "aws_route53_query_log" {
    min_instances = 1

    connection {
      subject   = "zone_id"
      connected = "zone_id"
    }
  }
}
