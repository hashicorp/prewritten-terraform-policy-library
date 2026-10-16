# Copyright IBM Corp. 2026

# At least one CloudTrail trail should be defined with security best practices

# The AWS Config rule cloudtrail-security-trail-enabled is compliant when at least one
# CloudTrail trail in the account meets all security best practices. Every trail in the
# plan is evaluated below, and each aws_cloudtrail resource passes when at least one trail
# in the plan is compliant. Trails that already exist outside this plan are not visible.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "cloudtrail-security-best-practices-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  ctsbp_trails = [for t in core::getresources("aws_cloudtrail", {}) : {
    logging_enabled = core::try(t.enable_logging, null) == null ? true : t.enable_logging
    include_global  = core::try(t.include_global_service_events, null) == null ? true : t.include_global_service_events
    multi_region    = core::try(t.is_multi_region_trail, null) == null ? false : t.is_multi_region_trail
    log_validation  = core::try(t.enable_log_file_validation, null) == null ? false : t.enable_log_file_validation
    kms_encrypted   = core::try(t.kms_key_id, null) == null ? false : t.kms_key_id != ""

    # Basic event selectors: management events for both reads and writes, with no exclusions.
    basic = [for s in(core::try(t.event_selector, null) == null ? [] : t.event_selector) : {
      include_mgmt = core::try(s.include_management_events, null) == null ? true : s.include_management_events
      has_excludes = core::length(core::try(s.exclude_management_event_sources, null) == null ? [] : s.exclude_management_event_sources) > 0
      rw           = core::try(s.read_write_type, null) == null ? "All" : s.read_write_type
    }]

    # Advanced event selectors: eventCategory = Management, optionally split by readOnly,
    # with no other limiting field.
    advanced = [for s in(core::try(t.advanced_event_selector, null) == null ? [] : t.advanced_event_selector) : {
      fs = core::try(s.field_selector, null) == null ? [] : s.field_selector
    }]
  }]

  ctsbp_results = [for t in local.ctsbp_trails : {
    basic_valid = [for s in t.basic : s if s.include_mgmt && !s.has_excludes]
    adv = [for a in t.advanced : {
      mgmt     = core::length([for f in a.fs : f if core::try(f.field, "") == "eventCategory" && core::contains(core::try(f.equals, null) == null ? [] : f.equals, "Management")]) > 0
      limiting = core::length([for f in a.fs : f if core::try(f.field, "") != "eventCategory" && core::try(f.field, "") != "readOnly"]) > 0
      has_ro   = core::length([for f in a.fs : f if core::try(f.field, "") == "readOnly"]) > 0
      reads    = core::length([for f in a.fs : f if core::try(f.field, "") == "readOnly" && core::contains(core::try(f.equals, null) == null ? [] : f.equals, "true")]) > 0
      writes   = core::length([for f in a.fs : f if core::try(f.field, "") == "readOnly" && core::contains(core::try(f.equals, null) == null ? [] : f.equals, "false")]) > 0
    }]
    t = t
  }]

  ctsbp_compliant = [for r in local.ctsbp_results : (
    r.t.logging_enabled && r.t.include_global && r.t.multi_region && r.t.log_validation && r.t.kms_encrypted &&
    (
      core::length(r.t.advanced) > 0
      ? (
        core::length([for a in r.adv : a if a.mgmt && !a.limiting && !a.has_ro]) > 0 ||
        (core::length([for a in r.adv : a if a.mgmt && !a.limiting && a.reads]) > 0 && core::length([for a in r.adv : a if a.mgmt && !a.limiting && a.writes]) > 0)
      )
      : (
        core::length(r.t.basic) == 0 ||
        core::length([for s in r.basic_valid : s if s.rw == "All"]) > 0 ||
        (core::length([for s in r.basic_valid : s if s.rw == "ReadOnly"]) > 0 && core::length([for s in r.basic_valid : s if s.rw == "WriteOnly"]) > 0)
      )
    )
  )]

  ctsbp_has_compliant_trail = core::length([for c in local.ctsbp_compliant : c if c]) > 0
}

resource_policy "aws_cloudtrail" "cloudtrail_security_best_practices" {
  enforcement_level = input.cloudtrail-security-best-practices-enforcement-level

  enforce {
    condition     = local.ctsbp_has_compliant_trail
    error_message = "No AWS CloudTrail trail in this plan meets all security best practices. At least one trail must have logging enabled, record global service events, be multi-region, have log file validation enabled, be encrypted with a KMS key, and log all management events for both reads and writes without exclusions."
  }
}
