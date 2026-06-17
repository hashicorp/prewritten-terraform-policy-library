# Copyright IBM Corp. 2026

# ELB.6 - Application, Gateway, and Network Load Balancers should have deletion protection enabled.

policy {}

input "elb-deletion-protection-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_lb" "deletion_protection_enabled" {
    enforcement_level = input.elb-deletion-protection-enabled-enforcement-level
    enforce {
        condition = core::try(attrs.enable_deletion_protection, false) == true
        error_message = "Load balancer (application, network or gateway) does not have deletion protection enabled. Set 'enable_deletion_protection = true' to prevent accidental deletion. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-6 for more details."
    }
}
