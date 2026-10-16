# Copyright IBM Corp. 2026

# EMR clusters should have Kerberos authentication enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "emr-kerberos-should-be-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_emr_cluster" "emr_kerberos_should_be_enabled" {
  enforcement_level = input.emr-kerberos-should-be-enabled-enforcement-level

  locals {
    kerberos_attrs_raw = core::try(attrs.kerberos_attributes, null)
    kerberos_attrs     = local.kerberos_attrs_raw != null ? local.kerberos_attrs_raw : []
    has_kerberos_attrs = core::length(local.kerberos_attrs) > 0

    ka = local.has_kerberos_attrs ? local.kerberos_attrs[0] : null

    realm_raw                   = local.has_kerberos_attrs ? core::try(local.ka.realm, null) : null
    kdc_admin_password_raw      = local.has_kerberos_attrs ? core::try(local.ka.kdc_admin_password, null) : null
    ad_domain_join_user_raw     = local.has_kerberos_attrs ? core::try(local.ka.ad_domain_join_user, null) : null
    ad_domain_join_password_raw = local.has_kerberos_attrs ? core::try(local.ka.ad_domain_join_password, null) : null

    has_realm        = local.realm_raw != null && local.realm_raw != ""
    has_kdc_password = local.kdc_admin_password_raw != null && local.kdc_admin_password_raw != ""
    has_ad_user      = local.ad_domain_join_user_raw != null && local.ad_domain_join_user_raw != ""
    has_ad_password  = local.ad_domain_join_password_raw != null && local.ad_domain_join_password_raw != ""

    check1_ok = local.has_realm || local.has_kdc_password

    check3_ok = !local.has_ad_user || local.has_ad_password

    kerberos_attrs_valid = local.has_kerberos_attrs && local.check1_ok && local.check3_ok

    security_configuration_raw = core::try(attrs.security_configuration, null)
    has_security_configuration = local.security_configuration_raw != null && local.security_configuration_raw != ""

    matching_security_configs = local.has_security_configuration ? core::getresources("aws_emr_security_configuration", {
      name = attrs.security_configuration
    }) : []

    matched_config  = core::length(local.matching_security_configs) > 0 ? local.matching_security_configs[0] : null
    config_json_raw = local.matched_config != null ? core::try(local.matched_config.configuration, null) : null
    config_json     = local.config_json_raw != null ? local.config_json_raw : ""

    contains_kerberos_string = core::contains_substring(local.config_json, "KerberosConfiguration")

    decoded_config  = local.contains_kerberos_string ? core::try(core::jsondecode(local.config_json), null) : null
    auth_config     = local.decoded_config != null ? core::try(local.decoded_config.AuthenticationConfiguration, null) : null
    kerberos_config = local.auth_config != null ? core::try(local.auth_config.KerberosConfiguration, null) : null

    security_config_valid = local.has_security_configuration && local.contains_kerberos_string && local.kerberos_config != null

    is_compliant = local.has_kerberos_attrs ? local.kerberos_attrs_valid : (local.has_security_configuration ? local.security_config_valid : false)
  }

  enforce {
    condition     = local.is_compliant
    error_message = "Amazon EMR cluster must have Kerberos authentication enabled with valid configuration. Either the 'kerberos_attributes' block must be properly configured (with 'realm' or 'kdc_admin_password' set, and 'ad_domain_join_password' present whenever 'ad_domain_join_user' is set) or a 'security_configuration' with a valid KerberosConfiguration must be attached."
  }
}
