# Copyright IBM Corp. 2026

policytest {
  targets = ["cognito-user-pool-password-policy-check.policy.hcl"]
}

inputs {
  requireLowercase = false
  requireUppercase = false
  requireNumbers   = false
  requireSymbols   = false
}

# Pass case: with every require input set to false, a pool that requires all character types still passes
resource "aws_cognito_user_pool" "pass_requirements_not_checked_pool_requires_all" {
  attrs = {
    name = "requires-all-pool"
    password_policy = [
      {
        minimum_length                   = 8
        require_lowercase                = true
        require_uppercase                = true
        require_numbers                  = true
        require_symbols                  = true
        temporary_password_validity_days = 7
      }
    ]
  }
}

# Pass case: with every require input set to false, a pool that requires no character types passes
resource "aws_cognito_user_pool" "pass_requirements_not_checked_pool_requires_none" {
  attrs = {
    name = "requires-none-pool"
    password_policy = [
      {
        minimum_length                   = 8
        require_lowercase                = false
        require_uppercase                = false
        require_numbers                  = false
        require_symbols                  = false
        temporary_password_validity_days = 7
      }
    ]
  }
}

# Fail case: turning the character checks off does not turn off the minimum length check
resource "aws_cognito_user_pool" "fail_minimum_length_still_checked" {
  expect_failure = true
  attrs = {
    name = "short-pool"
    password_policy = [
      {
        minimum_length                   = 6
        require_lowercase                = false
        require_uppercase                = false
        require_numbers                  = false
        require_symbols                  = false
        temporary_password_validity_days = 7
      }
    ]
  }
}
