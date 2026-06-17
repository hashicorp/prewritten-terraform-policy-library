# Copyright IBM Corp. 2026

# ELB.5 - Application and Classic Load Balancers logging should be enabled.

policy {}

input "elb-logging-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

input "s3_bucket_names" {
    type = string
    default = ""
}

locals {
    has_input = input.s3_bucket_names != ""
    trimmed_input = local.has_input ? core::split(",", core::trimspace(input.s3_bucket_names)) : []
    input_s3_buckets = [for bucket in local.trimmed_input: core::trimspace(bucket)]
}

# Check Classic Load Balancers (aws_elb)
resource_policy "aws_elb" "logging_enabled" {
    enforcement_level = input.elb-logging-enabled-enforcement-level
    locals {
        access_logs_attr = core::try(attrs.access_logs, null)
        has_access_logs = local.access_logs_attr != null ? core::length(local.access_logs_attr) > 0 : false
        logging_enabled = local.has_access_logs ? core::try(local.access_logs_attr[0].enabled, true) : false

        elb_s3_bucket_name = local.has_access_logs ? core::try(local.access_logs_attr[0].bucket, "") : ""
    }

    enforce {
        condition = local.logging_enabled == true
        error_message = "Classic Load Balancer does not have access logging enabled. Configure the 'access_logs' block with 'enabled = true' and specify an S3 bucket to store logs. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-5 for more details."
    }

    enforce {
        condition = core::length(local.input_s3_buckets) > 0 ? core::contains(local.input_s3_buckets, local.elb_s3_bucket_name) : true
        error_message = "Classic Load Balancer does not have valid s3 bucket for logging. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-5 for more details."
    }
}

resource_policy "aws_lb" "logging_enabled" {
    enforcement_level = input.elb-logging-enabled-enforcement-level
    # Only check Application Load Balancers (not Network or Gateway LBs)
    filter = core::try(attrs.load_balancer_type, "application") == "application"

    locals {
        access_logs_attr = core::try(attrs.access_logs, null)
        has_access_logs = local.access_logs_attr != null ? core::length(local.access_logs_attr) > 0 : false
        logging_enabled = local.has_access_logs ? core::try(local.access_logs_attr[0].enabled, false) : false

        elb_s3_bucket_name = local.has_access_logs ? core::try(local.access_logs_attr[0].bucket, "") : ""
    }

    enforce {
        condition = local.logging_enabled == true
        error_message = "Application Load Balancer does not have access logging enabled. Configure the 'access_logs' block with 'enabled = true' and specify an S3 bucket to store logs. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-5 for more details."
    }

    enforce {
        condition = core::length(local.input_s3_buckets) > 0 ? core::contains(local.input_s3_buckets, local.elb_s3_bucket_name) : true
        error_message = "Application Load Balancer does not have valid s3 bucket for logging. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-5 for more details."
    }
}
