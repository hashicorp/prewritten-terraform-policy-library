# Copyright IBM Corp. 2026

# Amazon EC2 instances should not use multiple ENIs

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.32.0, < 7.0.0"
    }
  }
}

input "ec2-instance-multiple-eni-check-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_instance" "no_multiple_enis" {
  enforcement_level = input.ec2-instance-multiple-eni-check-enforcement-level

  locals {
    # ENIs declared inline on the instance resource itself
    deprecated_eni_count = core::try(core::length(attrs.network_interface), 0)
    secondary_eni_count  = core::try(core::length(attrs.secondary_network_interface), 0)

    # 1 primary + inline declared ENIs. Separate attachment count comes from
    # the connected block below via self, but we need the total here.
    # The enforce condition below uses self to count matched attachments.
    inline_eni_count = 1 + local.deprecated_eni_count + local.secondary_eni_count
  }

  # reverse=true: aws_network_interface_attachment.instance_id is a user-declared
  # attribute pointing at this instance. The engine finds all attachments whose
  # instance_id equals the id of the current aws_instance being evaluated.
  connected "aws_network_interface_attachment" {
    connection {
      reverse = true
      subject = "instance_id"
      target  = "id"
    }

    # Each matched attachment is an additional ENI beyond the inline count.
    # The total must not exceed 1 (primary only). We enforce this by asserting
    # that the number of separate attachments, when added to the inline count,
    # does not push the total above 1.
    enforce {
      condition     = local.inline_eni_count + 1 <= 1
      error_message = "[EC2.17] Instance uses multiple ENIs. Multiple ENIs can create dual-homed instances with multiple subnets, adding network security complexity. Detach additional network interfaces to comply with security requirements"
    }
  }

  # Also enforce that inline-declared ENIs alone do not already exceed 1.
  enforce {
    condition     = local.inline_eni_count <= 1
    error_message = "[EC2.17] Instance declares multiple ENIs inline (network_interface or secondary_network_interface blocks). Multiple ENIs can create dual-homed instances with multiple subnets. Remove additional network interface declarations to comply with security requirements"
  }
}
