# Copyright IBM Corp. 2026

# Separate file: assumes inputs.exempted_projects = ["exempted-project"] (see testcase_gen.md 4.2 case 1 —
# this scenario requires a different `inputs {}` value than the default-input file).

policytest {
  targets = ["codebuild-project-privileged-mode-disabled.policy.hcl"]
}

inputs {
  codebuild-project-privileged-mode-disabled-exempted_projects = ["exempted-project"]
}

# PASS case: privileged_mode is true, but the project name is in exempted_projects
resource "aws_codebuild_project" "pass_privileged_mode_true_exempted" {
  attrs = {
    name         = "exempted-project"
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

# FAIL case: privileged_mode is true, project name is NOT in exempted_projects
# even though the exempted_projects list is non-empty for this file.
resource "aws_codebuild_project" "fail_privileged_mode_true_different_project" {
  expect_failure = true
  attrs = {
    name         = "other-project"
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
