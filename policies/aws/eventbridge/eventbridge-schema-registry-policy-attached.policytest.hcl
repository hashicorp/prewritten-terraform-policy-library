# Copyright IBM Corp. 2026

policytest {
  targets = ["eventbridge-schema-registry-policy-attached.policy.hcl"]
}

# ---------------------------------------------------------------------------
# PASS: registry has a matching aws_schemas_registry_policy with a non-empty
# registry_name and a non-empty policy document.
# ---------------------------------------------------------------------------
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

# ---------------------------------------------------------------------------
# FAIL: registry has no companion aws_schemas_registry_policy that matches
# its name (no resource policy attached).
# ---------------------------------------------------------------------------
resource "aws_schemas_registry" "fail_no_policy" {
  expect_failure = true
  attrs = {
    name = "registry-b"
  }
}

# ---------------------------------------------------------------------------
# FAIL: a aws_schemas_registry_policy exists, but its registry_name refers to
# a different registry than this one -- not a match.
# ---------------------------------------------------------------------------
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

# ---------------------------------------------------------------------------
# FAIL: a aws_schemas_registry_policy matches this registry's name, but its
# policy attribute is an empty string -- does not count as attached
# (mirrors Sentinel's length(policy) > 0 check).
# ---------------------------------------------------------------------------
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

# ---------------------------------------------------------------------------
# PASS: multiple aws_schemas_registry_policy resources exist; one (with a
# non-empty policy) matches this registry's name, another (also non-empty)
# does not -- still passes because at least one qualifying match exists.
# ---------------------------------------------------------------------------
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

# ---------------------------------------------------------------------------
# FAIL (edge case: missing attribute): registry's `name` attribute is
# entirely omitted. core::try(attrs.name, null) falls back to null, which is
# normalized to "" and treated as non-compliant.
# ---------------------------------------------------------------------------
resource "aws_schemas_registry" "fail_missing_name" {
  expect_failure = true
  attrs = {
    description = "registry with no name attribute set"
  }
}

# ---------------------------------------------------------------------------
# FAIL (edge case: explicit null): registry's `name` attribute is explicitly
# set to null. core::try returns null (not the default), which is then
# normalized to "" and treated as non-compliant -- matches the Sentinel
# "Registry name is undefined" branch.
# ---------------------------------------------------------------------------
resource "aws_schemas_registry" "fail_null_name" {
  expect_failure = true
  attrs = {
    name = null
  }
}
