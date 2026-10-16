# Copyright IBM Corp. 2026

policytest {
  targets = ["iam-managed-policy-should-be-attached-to-role.policy.hcl"]
}

# Separate file: assumes inputs.managed_policy_arns = [] (not configured).
# When no managed policies are required, the policy's top-level `filter`
# skips evaluation entirely for every aws_iam_role - matching the Sentinel
# source's early-return (`if length(trimmed_required_policies) is 0 { return
# true }` inside collection.reject) that produces zero violations when
# managedPolicyArns is unset. Because `filter` excludes every resource from
# evaluation in this scenario, no expect_failure case is possible or
# meaningful in this file - "nothing required, nothing to fail" is itself
# the behavior under test.
inputs {
  iam-managed-policy-should-be-attached-to-role-managed_policy_arns = []
}

# PASS: no managed policies are required, so a role with no attachments at
# all is compliant.
resource "aws_iam_role" "pass_no_requirements_no_attachments" {
  attrs = {
    name                = "role-no-requirements"
    assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

# PASS: no managed policies are required, so even a role whose attachments
# don't match anything in particular remains compliant (filter skips it
# before the attachment check ever runs).
resource "aws_iam_role" "pass_no_requirements_with_attachments" {
  attrs = {
    name                = "role-no-requirements-with-attachment"
    assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

resource "aws_iam_role_policy_attachment" "unrelated_attachment" {
  skip = true
  attrs = {
    role       = "role-no-requirements-with-attachment"
    policy_arn = "arn:aws:iam::aws:policy/SomeOtherPolicy"
  }
}
