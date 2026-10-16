# Copyright IBM Corp. 2026

policytest {
  targets = ["emr-kerberos-should-be-enabled.policy.hcl"]
}

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

# PASS: realm and password
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

# PASS: realm only
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

# PASS: password only
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

# FAIL: missing realm and password
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

# PASS: cross realm trust with password
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

# FAIL: cross realm trust missing password
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

# FAIL: empty kerberos list no security config
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

# PASS: kerberos null fallback to security config
resource "aws_emr_cluster" "pass_kerberos_null_fallback_to_security_config" {
  attrs = {
    name                   = "cluster-pass-null-fallback"
    release_label          = "emr-6.15.0"
    service_role           = "EMR_DefaultRole"
    kerberos_attributes    = null
    security_configuration = "security-config-with-kerberos"
  }
}

# FAIL: no kerberos attributes at all
resource "aws_emr_cluster" "fail_no_kerberos_attributes_at_all" {
  expect_failure = true
  attrs = {
    name          = "cluster-fail-no-attrs-at-all"
    release_label = "emr-6.15.0"
    service_role  = "EMR_DefaultRole"
  }
}

# FAIL: security config without kerberos
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

# FAIL: security config not found
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

# FAIL: invalid kerberos overrides valid security config
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
