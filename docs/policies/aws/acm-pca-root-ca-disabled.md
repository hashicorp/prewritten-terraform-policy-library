# AWS Private CA root certificate authority should be disabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure Network Configuration |

## Description

This control checks whether an AWS Private Certificate Authority (AWS Private CA) root certificate authority (CA) is disabled. The control fails if the root CA is enabled.

A root CA is the trust anchor of a CA hierarchy. An enabled root CA can issue certificates, which could be misused if compromised. By disabling the root CA after it has signed subordinate CA certificates, you reduce the attack surface and follow security best practices that limit exposure to the root CA. The root CA should only be brought online when it is needed to issue certificates for subordinate CAs, and should otherwise remain disabled.

This rule is covered by the [acm-pca-root-ca-disabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/acm/acm-pca-root-ca-disabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # acm-pca-root-ca-disabled.policytest.hcl... running
      # resource.aws_acmpca_certificate_authority.pass_root_ca_disabled... running
      # resource.aws_acmpca_certificate_authority.pass_root_ca_disabled... pass
      # resource.aws_acmpca_certificate_authority.fail_root_ca_enabled_explicit... running
      # resource.aws_acmpca_certificate_authority.fail_root_ca_enabled_explicit... pass
      # resource.aws_acmpca_certificate_authority.fail_root_ca_enabled_default... running
      # resource.aws_acmpca_certificate_authority.fail_root_ca_enabled_default... pass
      # resource.aws_acmpca_certificate_authority.pass_subordinate_ca_not_evaluated... running
      # resource.aws_acmpca_certificate_authority.pass_subordinate_ca_not_evaluated... pass
      # resource.aws_acmpca_certificate_authority.pass_subordinate_ca_default_type... running
      # resource.aws_acmpca_certificate_authority.pass_subordinate_ca_default_type... pass
      # acm-pca-root-ca-disabled.policytest.hcl... pass
```

---
