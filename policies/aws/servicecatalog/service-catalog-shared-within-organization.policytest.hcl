policytest {
  targets = ["service-catalog-shared-within-organization.policy.hcl"]
}

<<<<<<< HEAD
// Pass Case 1: ORGANIZATION_MEMBER_ACCOUNT (recommended type)
=======
# Pass Case 1: ORGANIZATION_MEMBER_ACCOUNT (recommended type)
>>>>>>> origin/main
resource "aws_servicecatalog_portfolio_share" "pass_organization_member_account" {
  attrs = {
    portfolio_id = "port-12345678"
    principal_id = "123456789012"
    type = "ORGANIZATION_MEMBER_ACCOUNT"
    share_principals = true
  }
}

<<<<<<< HEAD
// Pass Case 2: ORGANIZATIONAL_UNIT
=======
# Pass Case 2: ORGANIZATIONAL_UNIT
>>>>>>> origin/main
resource "aws_servicecatalog_portfolio_share" "pass_organizational_unit" {
  attrs = {
    portfolio_id = "port-12345678"
    principal_id = "ou-abcd-12345678"
    type = "ORGANIZATIONAL_UNIT"
    share_principals = true
  }
}

<<<<<<< HEAD
// Pass Case 3: ORGANIZATION
=======
# Pass Case 3: ORGANIZATION
>>>>>>> origin/main
resource "aws_servicecatalog_portfolio_share" "pass_organization" {
  attrs = {
    portfolio_id = "port-12345678"
    principal_id = "o-abcdefghij"
    type = "ORGANIZATION"
    share_principals = true
  }
}

<<<<<<< HEAD
// Fail Case 1: ACCOUNT (external account sharing - non-compliant)
=======
# Fail Case 1: ACCOUNT (external account sharing - non-compliant)
>>>>>>> origin/main
resource "aws_servicecatalog_portfolio_share" "fail_external_account" {
  expect_failure = true
  attrs = {
    portfolio_id = "port-12345678"
    principal_id = "999999999999"
    type = "ACCOUNT"
    share_principals = false
  }
}

<<<<<<< HEAD
// Fail Case 2: Invalid share type
=======
# Fail Case 2: Invalid share type
>>>>>>> origin/main
resource "aws_servicecatalog_portfolio_share" "fail_invalid_type" {
  expect_failure = true
  attrs = {
    portfolio_id = "port-12345678"
    principal_id = "123456789012"
    type = "INVALID_TYPE"
    share_principals = true
  }
}

<<<<<<< HEAD
// Fail Case 3: Missing type attribute (empty string from core::try default)
=======
# Fail Case 3: Missing type attribute (empty string from core::try default)
>>>>>>> origin/main
resource "aws_servicecatalog_portfolio_share" "fail_missing_type" {
  expect_failure = true
  attrs = {
    portfolio_id = "port-12345678"
    principal_id = "123456789012"
    share_principals = true
  }
}