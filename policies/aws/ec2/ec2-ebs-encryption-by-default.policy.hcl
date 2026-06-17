# EC2.7 - EBS Default Encryption Should Be Enabled.

policy {}

input "ec2-ebs-encryption-by-default-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_ebs_encryption_by_default" "encryption_enabled" {
    enforcement_level = input.ec2-ebs-encryption-by-default-enforcement-level
    enforce {
        condition = core::try(attrs.enabled, true) == true
        error_message = "EBS default encryption resource must have 'enabled = true'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-7 for more details."
    }
}