# Copyright IBM Corp. 2026

# Amazon EC2 paravirtual instance types should not be used

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "ec2-paravirtual-instance-check-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_instance" "no_paravirtual_instances" {
  enforcement_level = input.ec2-paravirtual-instance-check-enforcement-level

  locals {
    instance_ami_id = core::try(attrs.ami, "")
  }

  # Outward traversal (reverse=false, default): attrs.ami on aws_instance is
  # user-declared and known at plan time. The engine finds the aws_ami resource
  # whose id equals that value. aws_ami.id is computed but only appears as a
  # match target — it is never resolved as a lookup key from scratch.
  #
  # If no aws_ami resource in the plan matches (e.g. the AMI is a data source
  # or external), the connected block has zero matches and enforce does not
  # fire — the can_validate guard is implicit through cardinality absence.
  connected "aws_ami" {
    connection {
      subject = "ami"
      target  = "id"
    }

    enforce {
      condition     = core::try(self.virtualization_type, "") == "hvm"
      error_message = "EC2 instance uses AMI '${local.instance_ami_id}' with virtualization type '${core::try(self.virtualization_type, "unknown")}'. Paravirtual instances are not allowed. Use an HVM AMI instead"
    }
  }
}
