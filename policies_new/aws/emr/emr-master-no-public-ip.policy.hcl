# Copyright IBM Corp. 2026

# Amazon EMR cluster primary nodes should not have public IP addresses

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "emr-master-no-public-ip-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_emr_cluster" "emr_master_no_public_ip" {
  enforcement_level = input.emr-master-no-public-ip-enforcement-level

  # Block 1: scalar case — ec2_attributes.subnet_id holds a single reference.
  # Label "single_subnet" disambiguates from block 2 (same target resource type)
  # and exposes connected.single_subnet.matched to the top-level enforce below.
  connected "aws_subnet" "single_subnet" {
    connection {
      subject = "ec2_attributes.subnet_id"
      target  = "id"
    }

    enforce {
      condition     = !core::try(self.map_public_ip_on_launch, false)
      error_message = "Subnet '${self.id}' referenced by EMR cluster has map_public_ip_on_launch enabled. Use a private subnet to prevent master nodes from receiving public IP addresses"
    }
  }

  # Block 2: list case — ec2_attributes.subnet_ids holds multiple references.
  # each unrolls into one independent evaluation per element.
  connected "aws_subnet" "multi_subnet" {
    each "ec2_attributes.subnet_ids" {
      connection {
        subject = "ec2_attributes.subnet_ids[${each.index}]"
        target  = "id"
      }

      enforce {
        condition     = !core::try(self.map_public_ip_on_launch, false)
        error_message = "Subnet '${self.id}' at index ${each.index} in EMR cluster ec2_attributes.subnet_ids has map_public_ip_on_launch enabled. Use a private subnet to prevent master nodes from receiving public IP addresses"
      }
    }
  }

  # OR existence check: the cluster must use at least one of the two subnet
  # fields. connected.label.matched is true if the named block produced at least
  # one match. This is the Gap 6 resolution from Decision 10.
  enforce {
    condition     = connected.single_subnet.matched || connected.multi_subnet.matched
    error_message = "EMR cluster must be launched in a VPC subnet. Configure ec2_attributes with subnet_id or subnet_ids"
  }
}
