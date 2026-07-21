# Copyright IBM Corp. 2026

# Policy: EC2.24 - Amazon EC2 paravirtual instance types should not be used


policy {}

input "ec2-paravirtual-instance-check-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_instance" "no_paravirtual_instances" {
  enforcement_level = input.ec2-paravirtual-instance-check-enforcement-level
  connected "aws_ami" {
    connection {
      subject   = "ami"
      connected = "id"
    }

    enforce {
      condition     = core::try(connected.aws_ami.virtualization_type == "hvm", true)
      error_message = "EC2 instance uses AMI '${attrs.ami}' with virtualization type '${core::try(connected.aws_ami.virtualization_type, "")}'. Paravirtual instances are not allowed. Use an HVM AMI instead. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-24 for more details."
    }
  }
}
