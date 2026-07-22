# Copyright IBM Corp. 2026

# ELB.18 - Application and Network Load Balancer listeners should use secure protocols.

policy {}

input "elbv2-listener-encryption-in-transit-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_lb_listener" "secure_protocol_check" {
  enforcement_level = input.elbv2-listener-encryption-in-transit-enforcement-level

  connected "aws_lb" {
    connection {
      subject   = "load_balancer_arn"
      connected = "arn"
    }

    enforce {
      condition = (
        (core::try(connected.aws_lb.load_balancer_type, "application") == "application" && core::try(attrs.protocol, "") == "HTTPS") ||
        (core::try(connected.aws_lb.load_balancer_type, "application") == "network" && core::try(attrs.protocol, "") == "TLS")
      )
      error_message = "Load balancer listener must use secure protocol: HTTPS for Application Load Balancers or TLS for Network Load Balancers. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-18 for more details."
    }
  }
}

resource_policy "aws_lb_listener" "unresolved_listener_check" {
  enforcement_level = input.elbv2-listener-encryption-in-transit-enforcement-level
  filter            = core::try(attrs.protocol, "") != "HTTPS"

  connected "aws_lb" {
    connection {
      subject   = "load_balancer_arn"
      connected = "arn"
    }

    min_instances = 1
  }
}
