# Copyright IBM Corp. 2026

# EC2.4 - Stopped EC2 instances should be removed after a specified time period.

policy {}

input "AllowedDays" {
    type    = number
    default = 30
}

resource_policy "aws_instance" "stopped_instances_check" {
    locals {
        instance_state   = core::try(attrs.instance_state, "")
        instance_tags    = core::try(attrs.tags, {})
        stopped_date_raw = core::try(local.instance_tags["StoppedDate"], "")

        is_stopped       = local.instance_state == "stopped"
        has_stopped_date = local.stopped_date_raw != ""
    }

    enforce {
        condition     = input.AllowedDays >= 1 && input.AllowedDays <= 365
        error_message = "input.AllowedDays must be between 1 and 365."
    }

    enforce {
        condition     = !local.is_stopped || local.has_stopped_date
        error_message = "Stopped EC2 instance must include a 'StoppedDate' tag so external tooling can evaluate it against the configured AllowedDays threshold. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-4 for more details."
    }
}
