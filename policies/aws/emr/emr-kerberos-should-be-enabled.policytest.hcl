# Copyright IBM Corp. 2026

policytest {
  targets = ["emr-kerberos-should-be-enabled.policy.hcl"]
}

# ---------------------------------------------------------------------------
# Companion aws_emr_security_configuration mocks used by core::getresources()
# lookups below. skip = true because no resource_policy targets this type
# directly; these resources exist only to be looked up by name.
# ---------------------------------------------------------------------------
resource "aws_emr_security_configuration" "with_kerberos" {
  skip = true
  attrs = {
    name          = "security-config-with-kerberos"
    configuration = "{\"AuthenticationConfiguration\":{\"KerberosConfiguration\":{\"ProviderType\":\"ClusterDedicatedKdc\",\"ClusterDedicatedKdcConfiguration\":{\"TicketLifetimeInHours\":24}}}}"
  }
}

resource "aws_emr_security_configuration" "without_kerberos" {
  skip = true
  attrs = {
    name          = "security-config-without-kerberos"
    configuration = "{\"EncryptionConfiguration\":{\"AtRestEncryptionConfiguration\":{\"S3EncryptionConfiguration\":{\"EncryptionMode\":\"SSE-S3\"}}}}"
  }
}

# ---------------------------------------------------------------------------
# PASS: kerberos_attributes with both realm and kdc_admin_password set.
# ---------------------------------------------------------------------------
resource "aws_emr_cluster" "pass_realm_and_password" {
  attrs = {
    name                   = "cluster-pass-realm-and-password"
    release_label          = "emr-6.15.0"
    service_role           = "EMR_DefaultRole"
    security_configuration = null
    kerberos_attributes = [{
      realm                                = "EC2.INTERNAL"
      kdc_admin_password                   = "SuperSecretPassword123"
      ad_domain_join_user                  = null
      ad_domain_join_password              = null
      cross_realm_trust_principal_password = null
    }]
  }
}

# ---------------------------------------------------------------------------
# PASS: kerberos_attributes with only realm set (kdc_admin_password empty).
# ---------------------------------------------------------------------------
resource "aws_emr_cluster" "pass_realm_only" {
  attrs = {
    name                   = "cluster-pass-realm-only"
    release_label          = "emr-6.15.0"
    service_role           = "EMR_DefaultRole"
    security_configuration = null
    kerberos_attributes = [{
      realm                                = "EC2.INTERNAL"
      kdc_admin_password                   = ""
      ad_domain_join_user                  = null
      ad_domain_join_password              = null
      cross_realm_trust_principal_password = null
    }]
  }
}

# ---------------------------------------------------------------------------
# PASS: kerberos_attributes with only kdc_admin_password set (realm empty).
# ---------------------------------------------------------------------------
resource "aws_emr_cluster" "pass_password_only" {
  attrs = {
    name                   = "cluster-pass-password-only"
    release_label          = "emr-6.15.0"
    service_role           = "EMR_DefaultRole"
    security_configuration = null
    kerberos_attributes = [{
      realm                                = ""
      kdc_admin_password                   = "SuperSecretPassword123"
      ad_domain_join_user                  = null
      ad_domain_join_password              = null
      cross_realm_trust_principal_password = null
    }]
  }
}

# ---------------------------------------------------------------------------
# FAIL: kerberos_attributes present but neither realm nor kdc_admin_password
# is set (both empty strings).
# ---------------------------------------------------------------------------
resource "aws_emr_cluster" "fail_missing_realm_and_password" {
  expect_failure = true
  attrs = {
    name                   = "cluster-fail-missing-realm-and-password"
    release_label          = "emr-6.15.0"
    service_role           = "EMR_DefaultRole"
    security_configuration = null
    kerberos_attributes = [{
      realm                                = ""
      kdc_admin_password                   = ""
      ad_domain_join_user                  = null
      ad_domain_join_password              = null
      cross_realm_trust_principal_password = null
    }]
  }
}

# ---------------------------------------------------------------------------
# PASS: cross-realm trust configured correctly (ad_domain_join_user AND
# ad_domain_join_password both set).
# ---------------------------------------------------------------------------
resource "aws_emr_cluster" "pass_cross_realm_trust_with_password" {
  attrs = {
    name                   = "cluster-pass-cross-realm-trust"
    release_label          = "emr-6.15.0"
    service_role           = "EMR_DefaultRole"
    security_configuration = null
    kerberos_attributes = [{
      realm                                = "EC2.INTERNAL"
      kdc_admin_password                   = "SuperSecretPassword123"
      ad_domain_join_user                  = "join-user"
      ad_domain_join_password              = "join-password"
      cross_realm_trust_principal_password = null
    }]
  }
}

# ---------------------------------------------------------------------------
# FAIL: ad_domain_join_user set but ad_domain_join_password NOT set.
# ---------------------------------------------------------------------------
resource "aws_emr_cluster" "fail_cross_realm_trust_missing_password" {
  expect_failure = true
  attrs = {
    name                   = "cluster-fail-cross-realm-trust"
    release_label          = "emr-6.15.0"
    service_role           = "EMR_DefaultRole"
    security_configuration = null
    kerberos_attributes = [{
      realm                                = "EC2.INTERNAL"
      kdc_admin_password                   = "SuperSecretPassword123"
      ad_domain_join_user                  = "join-user"
      ad_domain_join_password              = null
      cross_realm_trust_principal_password = null
    }]
  }
}

# ---------------------------------------------------------------------------
# FAIL (empty collection): kerberos_attributes is an explicit empty list and
# no security_configuration is set.
# ---------------------------------------------------------------------------
resource "aws_emr_cluster" "fail_empty_kerberos_list_no_security_config" {
  expect_failure = true
  attrs = {
    name                   = "cluster-fail-empty-kerberos-list"
    release_label          = "emr-6.15.0"
    service_role           = "EMR_DefaultRole"
    security_configuration = null
    kerberos_attributes    = []
  }
}

# ---------------------------------------------------------------------------
# PASS (null normalization): kerberos_attributes explicitly null, falls back
# to a security_configuration whose JSON contains KerberosConfiguration.
# ---------------------------------------------------------------------------
resource "aws_emr_cluster" "pass_kerberos_null_fallback_to_security_config" {
  attrs = {
    name                   = "cluster-pass-null-fallback"
    release_label          = "emr-6.15.0"
    service_role           = "EMR_DefaultRole"
    kerberos_attributes    = null
    security_configuration = "security-config-with-kerberos"
  }
}

# ---------------------------------------------------------------------------
# FAIL (missing attribute): kerberos_attributes and security_configuration
# keys are entirely omitted from attrs (not just null).
# ---------------------------------------------------------------------------
resource "aws_emr_cluster" "fail_no_kerberos_attributes_at_all" {
  expect_failure = true
  attrs = {
    name          = "cluster-fail-no-attrs-at-all"
    release_label = "emr-6.15.0"
    service_role  = "EMR_DefaultRole"
  }
}

# ---------------------------------------------------------------------------
# FAIL: security_configuration is set and matches a real security
# configuration resource, but that configuration does not contain Kerberos.
# ---------------------------------------------------------------------------
resource "aws_emr_cluster" "fail_security_config_without_kerberos" {
  expect_failure = true
  attrs = {
    name                   = "cluster-fail-security-config-no-kerberos"
    release_label          = "emr-6.15.0"
    service_role           = "EMR_DefaultRole"
    kerberos_attributes    = null
    security_configuration = "security-config-without-kerberos"
  }
}

# ---------------------------------------------------------------------------
# FAIL: security_configuration references a name that does not match any
# aws_emr_security_configuration resource in the plan.
# ---------------------------------------------------------------------------
resource "aws_emr_cluster" "fail_security_config_not_found" {
  expect_failure = true
  attrs = {
    name                   = "cluster-fail-security-config-not-found"
    release_label          = "emr-6.15.0"
    service_role           = "EMR_DefaultRole"
    kerberos_attributes    = null
    security_configuration = "nonexistent-security-config"
  }
}

# ---------------------------------------------------------------------------
# FAIL: kerberos_attributes is present but invalid, AND a valid matching
# security_configuration is also attached. kerberos_attributes takes
# precedence per the original Sentinel logic, so this must still fail.
# ---------------------------------------------------------------------------
resource "aws_emr_cluster" "fail_invalid_kerberos_overrides_valid_security_config" {
  expect_failure = true
  attrs = {
    name                   = "cluster-fail-invalid-kerberos-overrides"
    release_label          = "emr-6.15.0"
    service_role           = "EMR_DefaultRole"
    security_configuration = "security-config-with-kerberos"
    kerberos_attributes = [{
      realm                                = ""
      kdc_admin_password                   = ""
      ad_domain_join_user                  = null
      ad_domain_join_password              = null
      cross_realm_trust_principal_password = null
    }]
  }
}
