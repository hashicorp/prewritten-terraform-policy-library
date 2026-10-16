# Copyright IBM Corp. 2026

policytest {
  targets = ["eventbridge-schema-registry-policy-attached.policy.hcl"]
}

# PASS: with policy
resource "aws_schemas_registry" "pass_with_policy" {
  attrs = {
    name        = "registry-a"
    description = "Registry with an attached resource policy"
  }
}

resource "aws_schemas_registry_policy" "policy_for_registry_a" {
  skip = true
  attrs = {
    registry_name = "registry-a"
    policy        = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

# FAIL: no policy
resource "aws_schemas_registry" "fail_no_policy" {
  expect_failure = true
  attrs = {
    name = "registry-b"
  }
}

# FAIL: mismatched name
resource "aws_schemas_registry" "fail_mismatched_name" {
  expect_failure = true
  attrs = {
    name = "registry-c"
  }
}

resource "aws_schemas_registry_policy" "mismatched_policy" {
  skip = true
  attrs = {
    registry_name = "registry-x"
    policy        = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

# FAIL: empty policy
resource "aws_schemas_registry" "fail_empty_policy" {
  expect_failure = true
  attrs = {
    name = "registry-d"
  }
}

resource "aws_schemas_registry_policy" "empty_policy_for_d" {
  skip = true
  attrs = {
    registry_name = "registry-d"
    policy        = ""
  }
}

# PASS: multiple policies
resource "aws_schemas_registry" "pass_multiple_policies" {
  attrs = {
    name = "registry-e"
  }
}

resource "aws_schemas_registry_policy" "policy_for_e" {
  skip = true
  attrs = {
    registry_name = "registry-e"
    policy        = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

resource "aws_schemas_registry_policy" "another_unrelated_policy" {
  skip = true
  attrs = {
    registry_name = "registry-f"
    policy        = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

# FAIL: missing name
resource "aws_schemas_registry" "fail_missing_name" {
  expect_failure = true
  attrs = {
    description = "registry with no name attribute set"
  }
}

# FAIL: null name
resource "aws_schemas_registry" "fail_null_name" {
  expect_failure = true
  attrs = {
    name = null
  }
}
