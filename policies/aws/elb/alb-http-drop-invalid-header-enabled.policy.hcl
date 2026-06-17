# Copyright IBM Corp. 2026

# ELB.4 - Application Load Balancer should drop invalid HTTP headers.

policy {}

input "alb-http-drop-invalid-header-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_lb" "drop_invalid_header_fields_enabled" {
    enforcement_level = input.alb-http-drop-invalid-header-enabled-enforcement-level
    filter = core::try(attrs.load_balancer_type, "application") == "application"

    locals {
        drop_invalid_header_fields_enabled = core::try(attrs.drop_invalid_header_fields, false)
    }

    enforce {
        condition = local.drop_invalid_header_fields_enabled == true
        error_message = "Application Load Balancer must set drop_invalid_header_fields = true to drop invalid HTTP headers. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-4 for more details."
    }
}
