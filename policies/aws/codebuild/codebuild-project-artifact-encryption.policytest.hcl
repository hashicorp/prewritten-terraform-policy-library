# Copyright IBM Corp. 2026

policytest {
  targets = ["codebuild-project-artifact-encryption.policy.hcl"]
}

# ---------------------------------------------------------------------------
# Shared required attributes used across all mocks (not evaluated by the
# policy, but required by the aws_codebuild_project resource schema):
#   name, service_role, environment, source
# ---------------------------------------------------------------------------

# PASS: primary artifact explicitly encrypted (encryption_disabled = false)
resource "aws_codebuild_project" "pass_primary_encrypted" {
  attrs = {
    name         = "project-pass-primary-encrypted"
    service_role = "arn:aws:iam::123456789012:role/service-role/codebuild-role"
    artifacts = [
      {
        type                = "S3"
        location            = "test-bucket"
        encryption_disabled = false
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
        type     = "CODECOMMIT"
        location = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/test-repo"
      }
    ]
  }
}

# FAIL: primary artifact explicitly NOT encrypted (encryption_disabled = true)
resource "aws_codebuild_project" "fail_primary_not_encrypted" {
  expect_failure = true
  attrs = {
    name         = "project-fail-primary-not-encrypted"
    service_role = "arn:aws:iam::123456789012:role/service-role/codebuild-role"
    artifacts = [
      {
        type                = "S3"
        location            = "test-bucket"
        encryption_disabled = true
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
        type     = "CODECOMMIT"
        location = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/test-repo"
      }
    ]
  }
}

# PASS: encryption_disabled omitted entirely -> defaults to false (encrypted)
resource "aws_codebuild_project" "pass_primary_encryption_disabled_omitted" {
  attrs = {
    name         = "project-pass-encryption-disabled-omitted"
    service_role = "arn:aws:iam::123456789012:role/service-role/codebuild-role"
    artifacts = [
      {
        type     = "S3"
        location = "test-bucket"
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
        type     = "CODECOMMIT"
        location = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/test-repo"
      }
    ]
  }
}

# PASS: type is NO_ARTIFACTS -> encryption_disabled is ignored even if true
resource "aws_codebuild_project" "pass_no_artifacts_type_exempt" {
  attrs = {
    name         = "project-pass-no-artifacts-type"
    service_role = "arn:aws:iam::123456789012:role/service-role/codebuild-role"
    artifacts = [
      {
        type                = "NO_ARTIFACTS"
        encryption_disabled = true
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
        type     = "CODECOMMIT"
        location = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/test-repo"
      }
    ]
  }
}

# FAIL: primary artifact encrypted, but secondary artifact is NOT encrypted
resource "aws_codebuild_project" "fail_secondary_not_encrypted" {
  expect_failure = true
  attrs = {
    name         = "project-fail-secondary-not-encrypted"
    service_role = "arn:aws:iam::123456789012:role/service-role/codebuild-role"
    artifacts = [
      {
        type                = "S3"
        location            = "test-bucket"
        encryption_disabled = false
      }
    ]
    secondary_artifacts = [
      {
        type                = "S3"
        location            = "test-bucket-secondary"
        artifact_identifier = "secondary"
        encryption_disabled = true
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
        type     = "CODECOMMIT"
        location = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/test-repo"
      }
    ]
  }
}

# PASS: both primary and secondary artifacts are encrypted
resource "aws_codebuild_project" "pass_secondary_encrypted" {
  attrs = {
    name         = "project-pass-secondary-encrypted"
    service_role = "arn:aws:iam::123456789012:role/service-role/codebuild-role"
    artifacts = [
      {
        type                = "S3"
        location            = "test-bucket"
        encryption_disabled = false
      }
    ]
    secondary_artifacts = [
      {
        type                = "S3"
        location            = "test-bucket-secondary"
        artifact_identifier = "secondary"
        encryption_disabled = false
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
        type     = "CODECOMMIT"
        location = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/test-repo"
      }
    ]
  }
}

# PASS: secondary_artifacts entirely absent -> normalized to [] (no violation)
resource "aws_codebuild_project" "pass_no_secondary_artifacts" {
  attrs = {
    name         = "project-pass-no-secondary-artifacts"
    service_role = "arn:aws:iam::123456789012:role/service-role/codebuild-role"
    artifacts = [
      {
        type                = "S3"
        location            = "test-bucket"
        encryption_disabled = false
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
        type     = "CODECOMMIT"
        location = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/test-repo"
      }
    ]
  }
}

# FAIL: multiple secondary artifacts, at least one is NOT encrypted
resource "aws_codebuild_project" "fail_multiple_secondary_one_unencrypted" {
  expect_failure = true
  attrs = {
    name         = "project-fail-multiple-secondary"
    service_role = "arn:aws:iam::123456789012:role/service-role/codebuild-role"
    artifacts = [
      {
        type                = "S3"
        location            = "test-bucket"
        encryption_disabled = false
      }
    ]
    secondary_artifacts = [
      {
        type                = "S3"
        location            = "test-bucket-secondary-1"
        artifact_identifier = "secondary-1"
        encryption_disabled = false
      },
      {
        type                = "S3"
        location            = "test-bucket-secondary-2"
        artifact_identifier = "secondary-2"
        encryption_disabled = true
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
        type     = "CODECOMMIT"
        location = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/test-repo"
      }
    ]
  }
}

# PASS: encryption_disabled explicitly set to null -> normalized to false (encrypted)
resource "aws_codebuild_project" "pass_primary_encryption_disabled_null" {
  attrs = {
    name         = "project-pass-encryption-disabled-null"
    service_role = "arn:aws:iam::123456789012:role/service-role/codebuild-role"
    artifacts = [
      {
        type                = "S3"
        location            = "test-bucket"
        encryption_disabled = null
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
        type     = "CODECOMMIT"
        location = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/test-repo"
      }
    ]
  }
}
