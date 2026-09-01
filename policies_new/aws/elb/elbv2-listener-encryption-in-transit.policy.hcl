# Copyright IBM Corp. 2026

# Application and Network Load Balancer listeners should use secure protocols to encrypt data in transit

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "elbv2-listener-encryption-in-transit-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_lb_listener" "secure_protocol_check" {
  enforcement_level = input.elbv2-listener-encryption-in-transit-enforcement-level

  locals {
    protocol = core::try(attrs.protocol, "")
  }

  # Outward traversal: aws_lb_listener.load_balancer_arn references the aws_lb.
  # Terraform's reference graph resolves the edge — aws_lb.arn does not need to
  # be a known string at plan time.
  connected "aws_lb" {
    connection {
      subject = "load_balancer_arn"
      target  = "arn"
    }

    enforce {
      condition = (
        (core::try(self.load_balancer_type, "application") == "application" && local.protocol == "HTTPS") ||
        (core::try(self.load_balancer_type, "application") == "network"     && local.protocol == "TLS")
      )
      error_message = "Load balancer listener must use secure protocol: HTTPS for Application Load Balancers or TLS for Network Load Balancers"
    }
  }
}
