# Copyright IBM Corp. 2026

# At least one CloudTrail trail should log Amazon S3 data events

# The AWS Config rule cloudtrail-s3-dataevents-enabled is compliant when at least one
# CloudTrail trail logs Amazon S3 data events. Every trail in the plan is evaluated below,
# and each aws_cloudtrail resource passes when at least one trail in the plan logs S3 data
# events for the required buckets. Trails that already exist outside this plan are not visible.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "cloudtrail-s3-dataevents-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

input "cloudtrail-s3-dataevents-enabled-s3_bucket_names" {
  type        = string
  default     = ""
  description = "Comma-separated list of S3 bucket names for which S3 data-event logging must be enabled by at least one trail. Empty string (default) requires logging for all S3 buckets."
}

locals {
  s3de_targets     = [for b in core::split(",", input.cloudtrail-s3-dataevents-enabled-s3_bucket_names) : core::trimspace(b) if core::trimspace(b) != ""]
  s3de_all_buckets = ["", "arn:aws:s3:::*/*", "arn:aws:s3:::", "arn:aws:s3"]

  s3de_trails = [for t in core::getresources("aws_cloudtrail", {}) : {
    logging_enabled = core::try(t.enable_logging, null) == null ? true : t.enable_logging

    # Legacy event selectors: read_write_type All and an AWS::S3::Object data resource.
    legacy_values = [
      for es in(core::try(t.event_selector, null) == null ? [] : t.event_selector) : [
        for dr in(core::try(es.data_resource, null) == null ? [] : es.data_resource) :
        { vals = core::try(dr.values, null) == null ? [] : [for v in dr.values : v] }
        if core::try(dr.type, "") == "AWS::S3::Object"
      ]
      if(core::try(es.read_write_type, null) == null ? "All" : es.read_write_type) == "All"
    ]

    # Advanced event selectors: eventCategory = Data, resources.type = AWS::S3::Object,
    # no eventName filter.
    advanced = [
      for aes in(core::try(t.advanced_event_selector, null) == null ? [] : t.advanced_event_selector) : {
        fs = core::try(aes.field_selector, null) == null ? [] : aes.field_selector
      }
    ]
  }]

  s3de_results = [for t in local.s3de_trails : {
    logging_enabled = t.logging_enabled

    # One entry per S3 data resource; an empty value list means all buckets.
    legacy = [for o in core::flatten(t.legacy_values) : o.vals]

    advanced = [for a in t.advanced : {
      data_s3 = (
        core::length([for f in a.fs : f if core::try(f.field, "") == "eventCategory" && core::contains(core::try(f.equals, null) == null ? [] : f.equals, "Data")]) > 0 &&
        core::length([for f in a.fs : f if core::try(f.field, "") == "resources.type" && core::contains(core::try(f.equals, null) == null ? [] : f.equals, "AWS::S3::Object")]) > 0 &&
        core::length([for f in a.fs : f if core::try(f.field, "") == "eventName"]) == 0
      )
      arn_equals     = core::flatten([for f in a.fs : core::try(f.equals, null) == null ? [] : f.equals if core::try(f.field, "") == "resources.ARN"])
      arn_not_equals = core::flatten([for f in a.fs : core::try(f.not_equals, null) == null ? [] : f.not_equals if core::try(f.field, "") == "resources.ARN"])
      arn_starts_with = core::flatten([for f in a.fs : core::try(f.starts_with, null) == null ? [] : f.starts_with if core::try(f.field, "") == "resources.ARN"])
      # ends_with and not_* operators narrow the selector in ways a plan cannot resolve
      # to bucket coverage, so any use of them is treated as not covering the buckets.
      arn_other_ops = core::flatten([for f in a.fs : core::concat(
        core::try(f.ends_with, null) == null ? [] : f.ends_with,
        core::try(f.not_starts_with, null) == null ? [] : f.not_starts_with,
        core::try(f.not_ends_with, null) == null ? [] : f.not_ends_with
      ) if core::try(f.field, "") == "resources.ARN"])
    }]
  }]

  # A value covers a bucket when it selects all buckets or the bucket itself.
  s3de_compliant = [for r in local.s3de_results : r.logging_enabled && (
    # Legacy selectors
    core::length([for vals in r.legacy : vals if
      core::length(vals) == 0 ||
      core::length([for v in vals : v if core::contains(local.s3de_all_buckets, v)]) > 0 ||
      (
        core::length(local.s3de_targets) > 0 &&
        core::length([for b in local.s3de_targets : b if core::length([for v in vals : v if core::startswith(v, "arn:aws:s3:::${b}/") || v == "arn:aws:s3:::${b}"]) > 0]) == core::length(local.s3de_targets)
      )
    ]) > 0
    ||
    # Advanced selectors
    core::length([for a in r.advanced : a if a.data_s3 && (
      core::length(a.arn_other_ops) == 0 &&
      core::length([for b in(core::length(local.s3de_targets) == 0 ? ["*"] : local.s3de_targets) : b if
        core::length(a.arn_starts_with) == 0 ||
        core::length([for v in a.arn_starts_with : v if core::contains(local.s3de_all_buckets, v) || (b != "*" && core::startswith("arn:aws:s3:::${b}/", v))]) > 0
      ]) == core::length(core::length(local.s3de_targets) == 0 ? ["*"] : local.s3de_targets) &&
      (
        core::length(local.s3de_targets) == 0
        ? (
          core::length(a.arn_not_equals) == 0 &&
          (core::length(a.arn_equals) == 0 || core::length([for v in a.arn_equals : v if core::contains(local.s3de_all_buckets, v)]) > 0)
        )
        : (
          core::length([for b in local.s3de_targets : b if core::length([for v in a.arn_not_equals : v if core::contains(local.s3de_all_buckets, v) || core::startswith(v, "arn:aws:s3:::${b}/") || v == "arn:aws:s3:::${b}"]) > 0]) == 0 &&
          (
            core::length(a.arn_equals) == 0 ||
            core::length([for b in local.s3de_targets : b if core::length([for v in a.arn_equals : v if core::contains(local.s3de_all_buckets, v) || core::startswith(v, "arn:aws:s3:::${b}/") || v == "arn:aws:s3:::${b}"]) > 0]) == core::length(local.s3de_targets)
          )
        )
      )
    )]) > 0
  )]

  s3de_has_compliant_trail = core::length([for c in local.s3de_compliant : c if c]) > 0
}

resource_policy "aws_cloudtrail" "s3_dataevents_enabled" {
  enforcement_level = input.cloudtrail-s3-dataevents-enabled-enforcement-level

  enforce {
    condition     = local.s3de_has_compliant_trail
    error_message = "No AWS CloudTrail trail in this plan logs Amazon S3 data events for the required buckets. At least one trail must have logging enabled and an event_selector with data_resource { type = \"AWS::S3::Object\" values = [\"arn:aws:s3\"] } and read_write_type All, or an advanced_event_selector with eventCategory = Data and resources.type = AWS::S3::Object and no eventName filter."
  }
}
