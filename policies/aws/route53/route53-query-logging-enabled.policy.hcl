# Copyright IBM Corp. 2026

# Route53.2: Route 53 public hosted zones should log DNS queries

policy {}

locals {
    all_query_logs = core::getresources("aws_route53_query_log", {})
    
    # Build lookup map for O(1) performance: zone_id -> query_log
    query_log_map = {
        for log in local.all_query_logs :
        log.zone_id => log
    }
}

resource_policy "aws_route53_zone" "dns_query_logging_enabled" {
    # Only check public hosted zones (private zones have vpc blocks)
    filter = core::try(core::length(attrs.vpc), 0) == 0
    
    locals {
        # Check if this zone has query logging configured
        has_query_logging = core::try(local.query_log_map[attrs.zone_id], null) != null
        
        zone_name = core::try(attrs.name, attrs.zone_id)
    }
    
    enforce {
        condition = local.has_query_logging
        error_message = "Route 53 public hosted zone '${local.zone_name}' must have DNS query logging enabled. Create an aws_route53_query_log resource with zone_id = ${attrs.zone_id}. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/route53-controls.html#route53-2 for more details."
    }
}
