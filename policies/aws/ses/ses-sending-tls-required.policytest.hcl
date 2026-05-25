policytest {
  targets = [
    "ses-sending-tls-required.policy.hcl"
  ]
}
<<<<<<< HEAD
// Pass case: SES v1 with TLS set to 'Require'
=======
# Pass case: SES v1 with TLS set to 'Require'
>>>>>>> origin/main
resource "aws_ses_configuration_set" "ses_v1_pass_tls_require" {
  attrs = {
    name = "compliant-config-set"
    delivery_options = [
      {
        tls_policy = "Require"
      }
    ]
  }
}

<<<<<<< HEAD
// Fail case: SES v1 with TLS set to 'Optional'
=======
# Fail case: SES v1 with TLS set to 'Optional'
>>>>>>> origin/main
resource "aws_ses_configuration_set" "ses_v1_fail_tls_optional" {
  expect_failure = true
  attrs = {
    name = "non-compliant-config-set"
    delivery_options = [
      {
        tls_policy = "Optional"
      }
    ]
  }
}

<<<<<<< HEAD
// Fail case: SES v1 without delivery_options block
=======
# Fail case: SES v1 without delivery_options block
>>>>>>> origin/main
resource "aws_ses_configuration_set" "ses_v1_fail_no_delivery_options" {
  expect_failure = true
  attrs = {
    name = "no-delivery-options-config-set"
  }
}

<<<<<<< HEAD
// Fail case: SES v1 with empty delivery_options (no tls_policy)
=======
# Fail case: SES v1 with empty delivery_options (no tls_policy)
>>>>>>> origin/main
resource "aws_ses_configuration_set" "ses_v1_fail_empty_delivery_options" {
  expect_failure = true
  attrs = {
    name = "empty-delivery-options-config-set"
    delivery_options = [
      {}
    ]
  }
}

<<<<<<< HEAD
// ============================================================================
// Tests for aws_sesv2_configuration_set (SES v2)
// ============================================================================

// Pass case: SES v2 with TLS set to 'REQUIRE'
=======
# ============================================================================
# Tests for aws_sesv2_configuration_set (SES v2)
# ============================================================================

# Pass case: SES v2 with TLS set to 'REQUIRE'
>>>>>>> origin/main
resource "aws_sesv2_configuration_set" "ses_v2_pass_tls_require" {
  attrs = {
    configuration_set_name = "compliant-v2-config-set"
    delivery_options = [
      {
        tls_policy = "REQUIRE"
      }
    ]
  }
}

<<<<<<< HEAD
// Fail case: SES v2 with TLS set to 'OPTIONAL'
=======
# Fail case: SES v2 with TLS set to 'OPTIONAL'
>>>>>>> origin/main
resource "aws_sesv2_configuration_set" "ses_v2_fail_tls_optional" {
  expect_failure = true
  attrs = {
    configuration_set_name = "non-compliant-v2-config-set"
    delivery_options = [
      {
        tls_policy = "OPTIONAL"
      }
    ]
  }
}

<<<<<<< HEAD
// Fail case: SES v2 without delivery_options block
=======
# Fail case: SES v2 without delivery_options block
>>>>>>> origin/main
resource "aws_sesv2_configuration_set" "ses_v2_fail_no_delivery_options" {
  expect_failure = true
  attrs = {
    configuration_set_name = "no-delivery-options-v2-config-set"
  }
}

<<<<<<< HEAD
// Fail case: SES v2 with empty delivery_options (no tls_policy)
=======
# Fail case: SES v2 with empty delivery_options (no tls_policy)
>>>>>>> origin/main
resource "aws_sesv2_configuration_set" "ses_v2_fail_empty_delivery_options" {
  expect_failure = true
  attrs = {
    configuration_set_name = "empty-delivery-options-v2-config-set"
    delivery_options = [
      {}
    ]
  }
}