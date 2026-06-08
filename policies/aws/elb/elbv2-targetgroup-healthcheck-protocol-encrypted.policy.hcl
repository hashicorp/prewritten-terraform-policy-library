# Copyright IBM Corp. 2026

# ELB.21 - Application and Network Load Balancer target groups should use encrypted health check protocols.

policy {}

resource_policy "aws_lb_target_group" "encrypted_health_check" {
    filter = attrs.target_type != "lambda"

    locals {
        health_check = core::try(attrs.health_check, [])
        has_health_check = core::length(local.health_check) > 0
        health_check_protocol = core::try(local.health_check[0].protocol, "")
    }

    enforce {
        condition = local.has_health_check && local.health_check_protocol == "HTTPS"
        error_message = "Target group does not use HTTPS for health checks. Set health_check.protocol = 'HTTPS' to ensure encrypted communication between the load balancer and targets. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-21 for more details."
    }
}
