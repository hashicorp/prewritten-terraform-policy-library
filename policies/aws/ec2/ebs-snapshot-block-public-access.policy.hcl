# EC2.182 - Amazon EBS Snapshots should not be publicly accessible.

policy {}

resource_policy "aws_ebs_snapshot_block_public_access" "block_all_sharing" {
    enforce {
        condition = core::try(attrs.state, "") == "block-all-sharing"
        error_message = "EBS snapshot block public access must have state set to 'block-all-sharing' to prevent public sharing of snapshots. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-182 for more details."
    }
}
