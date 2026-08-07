# Copyright IBM Corp. 2026

# EFS mount targets should not be associated with subnets that assign public IP addresses on launch

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "efs-mount-target-public-accessible-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_efs_mount_target" "no_public_subnet" {
  enforcement_level = input.efs-mount-target-public-accessible-enforcement-level

  connected "aws_subnet" {
    connection {
      subject = "subnet_id"
      target  = "id"
    }

    cardinality = {
      min_matches = 1
    }

    enforce {
      condition     = !core::try(self.map_public_ip_on_launch, false)
      error_message = "EFS mount target is associated with a subnet that assigns public IPv4 addresses on launch (map_public_ip_on_launch=true). Mount targets must only be placed in subnets that do not auto-assign public IPs"
    }
  }
}
