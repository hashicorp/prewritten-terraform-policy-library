# CloudTrail.5 - CloudTrail trails should be integrated with Amazon CloudWatch Logs.

policy {}

input "cloud-trail-cloud-watch-logs-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_cloudtrail" "cloud-watch-logs" {
    enforcement_level = input.cloud-trail-cloud-watch-logs-enabled-enforcement-level
    enforce {
        condition = core::try(attrs.cloud_watch_logs_group_arn, "") != ""
        error_message = "CloudTrail trail is not integrated with Amazon CloudWatch Logs. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudtrail-controls.html#cloudtrail-5 for more details."
    }
}
