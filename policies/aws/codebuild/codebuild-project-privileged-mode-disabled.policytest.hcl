# Copyright IBM Corp. 2026

policytest {
  targets = ["codebuild-project-privileged-mode-disabled.policy.hcl"]
}

# Default inputs: exempted_projects uses its default value ([]).
# Covers: privileged_mode=false (pass), privileged_mode=true without exemption (fail),
# privileged_mode attribute omitted (pass), privileged_mode explicitly null (pass).

# PASS case: privileged_mode explicitly set to false
resource "aws_codebuild_project" "pass_privileged_mode_false" {
  attrs = {
    name         = "test-project"
    service_role = "arn:aws:iam::123456789012:role/service-role/test-role"

    artifacts = [
      {
        type = "NO_ARTIFACTS"
      }
    ]

    environment = [
      {
        compute_type    = "BUILD_GENERAL1_SMALL"
        image           = "aws/codebuild/standard:7.0"
        type            = "LINUX_CONTAINER"
        privileged_mode = false
      }
    ]

    source = [
      {
        type     = "GITHUB"
        location = "https://github.com/example/example.git"
      }
    ]
  }
}

# FAIL case: privileged_mode set to true, project not in exempted_projects (default [])
resource "aws_codebuild_project" "fail_privileged_mode_true_not_exempted" {
  expect_failure = true
  attrs = {
    name         = "docker-build-project"
    service_role = "arn:aws:iam::123456789012:role/service-role/test-role"

    artifacts = [
      {
        type = "NO_ARTIFACTS"
      }
    ]

    environment = [
      {
        compute_type    = "BUILD_GENERAL1_SMALL"
        image           = "aws/codebuild/standard:7.0"
        type            = "LINUX_CONTAINER"
        privileged_mode = true
      }
    ]

    source = [
      {
        type     = "GITHUB"
        location = "https://github.com/example/example.git"
      }
    ]
  }
}

# PASS case: privileged_mode attribute entirely omitted from environment block
# (missing attribute -> core::try default is null -> normalized to false -> compliant)
resource "aws_codebuild_project" "pass_privileged_mode_missing_attribute" {
  attrs = {
    name         = "no-privileged-attr-project"
    service_role = "arn:aws:iam::123456789012:role/service-role/test-role"

    artifacts = [
      {
        type = "NO_ARTIFACTS"
      }
    ]

    environment = [
      {
        compute_type = "BUILD_GENERAL1_SMALL"
        image        = "aws/codebuild/standard:7.0"
        type         = "LINUX_CONTAINER"
      }
    ]

    source = [
      {
        type     = "GITHUB"
        location = "https://github.com/example/example.git"
      }
    ]
  }
}

# PASS case: privileged_mode explicitly set to null
# (two-step normalization pattern: explicit null -> normalized to false -> compliant)
resource "aws_codebuild_project" "pass_privileged_mode_null" {
  attrs = {
    name         = "null-privileged-attr-project"
    service_role = "arn:aws:iam::123456789012:role/service-role/test-role"

    artifacts = [
      {
        type = "NO_ARTIFACTS"
      }
    ]

    environment = [
      {
        compute_type    = "BUILD_GENERAL1_SMALL"
        image           = "aws/codebuild/standard:7.0"
        type            = "LINUX_CONTAINER"
        privileged_mode = null
      }
    ]

    source = [
      {
        type     = "GITHUB"
        location = "https://github.com/example/example.git"
      }
    ]
  }
}
