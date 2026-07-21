# Copyright IBM Corp. 2026

# Policy: EC2.17 - Amazon EC2 instances should not use multiple ENIs

policy {}

input "ec2-instance-multiple-eni-check-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_instance" "no_inline_multiple_enis" {
  enforcement_level = input.ec2-instance-multiple-eni-check-enforcement-level

  enforce {
    condition = (
      core::try(core::length(attrs.network_interface), 0) == 0 &&
      core::try(core::length(attrs.secondary_network_interface), 0) == 0
    )
    error_message = "[EC2.17] Instance must not configure deprecated or secondary network interface blocks. Multiple ENIs can create dual-homed instances with multiple subnets, adding network security complexity. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-17 for more details."
  }
}

resource_policy "aws_instance" "no_attached_multiple_enis" {
  enforcement_level = input.ec2-instance-multiple-eni-check-enforcement-level

  connected "aws_network_interface_attachment" {
    max_instances = 0

    connection {
      subject   = "id"
      connected = "instance_id"
    }
  }
}
