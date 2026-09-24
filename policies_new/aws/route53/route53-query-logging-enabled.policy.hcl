# Copyright IBM Corp. 2026

# Route 53 public hosted zones should log DNS queries

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "route53-query-logging-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_route53_zone" "dns_query_logging_enabled" {
  enforcement_level = input.route53-query-logging-enabled-enforcement-level
  # Only check public hosted zones (private zones have vpc blocks)
  filter = core::try(core::length(attrs.vpc), 0) == 0

  connected "aws_route53_query_log" {
    connection {
      subject = "zone_id"
      target  = "zone_id"
    }

    cardinality = {
      min_matches = 1
      error_message = "Route 53 public hosted zone must have DNS query logging enabled. Create an aws_route53_query_log resource with zone_id = ${attrs.zone_id}"
    }
  }
}
