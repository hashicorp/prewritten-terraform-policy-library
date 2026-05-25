# ELB.6 - Application, Gateway, and Network Load Balancers should have deletion protection enabled.

policy {}

resource_policy "aws_lb" "deletion_protection_enabled" {
    enforce {
        condition = core::try(attrs.enable_deletion_protection, false) == true
        error_message = "Load balancer (application, network or gateway) does not have deletion protection enabled. Set 'enable_deletion_protection = true' to prevent accidental deletion. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-6 for more details."
    }
}
