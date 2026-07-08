# Copyright IBM Corp. 2026

# Policy: DMS.9 - DMS endpoints should use SSL

policy {}

input "dms-endpoint-ssl-configured-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_dms_endpoint" "certificate_arn_required" {
  enforcement_level = input.dms-endpoint-ssl-configured-enforcement-level
  locals {
    certificate_arn     = core::try(attrs.certificate_arn, null)
    has_certificate_arn = local.certificate_arn != null && local.certificate_arn != ""
  }

  enforce {
    condition     = local.has_certificate_arn
    error_message = "Attribute 'certificate_arn' must not be empty for 'aws_dms_endpoint' resources. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dms-controls.html#dms-9 for more details."
  }
}
