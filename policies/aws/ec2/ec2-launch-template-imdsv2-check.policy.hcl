# EC2.170 - EC2 launch templates should use Instance Metadata Service Version 2 (IMDSv2).

policy {}

input "ec2-launch-template-imdsv2-check-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_launch_template" "imdsv2_required" {
    enforcement_level = input.ec2-launch-template-imdsv2-check-enforcement-level
    enforce {
        condition = core::try(attrs.metadata_options.http_tokens, "optional") == "required"
        error_message = "Launch template does not enforce IMDSv2. The metadata_options.http_tokens must be set to 'required'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-170 for more details."
    }
}