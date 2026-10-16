# Copyright IBM Corp. 2026

# EC2 instances should have an IAM instance profile attached

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "ec2-instance-profile-required-enforcement-level" {
  type    = string
  default = "advisory"
}

# The original Sentinel policy accepts IamInstanceProfileArnList as a comma-separated
# string param and parses it with strings.split/strings.trim_space. TFPolicy natively
# supports list(string) inputs, so the allow-list is modeled directly as a list here —
# no CSV parsing is required.
input "ec2-instance-profile-required-allowed_iam_instance_profiles" {
  type    = list(string)
  default = []
}

resource_policy "aws_instance" "ec2_instance_profile_required" {
  enforcement_level = input.ec2-instance-profile-required-enforcement-level

  locals {
    profile_raw   = core::try(attrs.iam_instance_profile, null)
    profile_set   = local.profile_raw != null && local.profile_raw != ""
    profile_value = local.profile_set ? local.profile_raw : ""

    # Derive a short profile name from an ARN-formatted value (the segment after the
    # last "/"). Plain profile names pass through unchanged. This mirrors the ARN
    # branch of the original Sentinel extract_instance_profile_name() function.
    # NOTE: The Sentinel "aws_iam_instance_profile.<name>" resource-reference branch
    # cannot occur here because tfplan already resolves resource references to their
    # literal attribute values before TFPolicy evaluation, so only the ARN and plain
    # name forms are relevant for aws_instance.iam_instance_profile.
    profile_name_parts = core::split("/", local.profile_value)
    profile_name       = core::length(local.profile_name_parts) > 1 ? local.profile_name_parts[core::length(local.profile_name_parts) - 1] : local.profile_value

    allowed_list   = input.ec2-instance-profile-required-allowed_iam_instance_profiles
    has_allow_list = core::length(local.allowed_list) > 0

    allowed_short_names = [for allowed in local.allowed_list :
      core::length(core::split("/", allowed)) > 1
      ? core::split("/", allowed)[core::length(core::split("/", allowed)) - 1]
      : allowed
    ]

    is_in_allow_list = core::contains(local.allowed_list, local.profile_value) || core::contains(local.allowed_short_names, local.profile_name)
  }

  # Violation: iam_instance_profile missing or empty.
  enforce {
    condition     = local.profile_set
    error_message = "EC2 instance must have an IAM instance profile attached. The 'iam_instance_profile' attribute is required for proper identity and access management."
  }

  # Violation: an allow-list is configured and the attached profile (or its ARN-derived
  # short name) does not match any entry in it. Vacuously true when no allow-list is set,
  # and skipped when the profile itself is missing (already caught by the enforce above).
  enforce {
    condition     = !local.has_allow_list || !local.profile_set || local.is_in_allow_list
    error_message = "EC2 instance is using an IAM instance profile that is not in the allowed list of IAM instance profile ARNs/names."
  }
}
