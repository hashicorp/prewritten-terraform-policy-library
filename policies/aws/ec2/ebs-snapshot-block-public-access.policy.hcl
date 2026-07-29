# Copyright IBM Corp. 2026

# EC2.182 - Amazon EBS Snapshots should not be publicly accessible.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.62.0, < 7.0.0"
    }
  }
}

input "ebs-snapshot-block-public-access-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_ebs_snapshot_block_public_access" "block_all_sharing" {
    enforcement_level = input.ebs-snapshot-block-public-access-enforcement-level
    enforce {
        condition = core::try(attrs.state, "") == "block-all-sharing"
        error_message = "EBS snapshot block public access must have state set to 'block-all-sharing' to prevent public sharing of snapshots. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-182 for more details."
    }
}
