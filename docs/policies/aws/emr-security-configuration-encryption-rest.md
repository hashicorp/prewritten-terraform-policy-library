# Amazon EMR security configurations should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether an Amazon EMR security configuration has encryption at rest enabled. The control fails if the security configuration doesn't enable encryption at rest.

Data at rest refers to data that's stored in persistent, non-volatile storage for any duration. Encrypting data at rest helps you protect its confidentiality, which reduces the risk that an unauthorized user can access it.

This rule is covered by the [emr-security-configuration-encryption-rest](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/emr/emr-security-configuration-encryption-rest.policy.hcl) policy.

## Policy Results

```bash
trace:
      # emr-security-configuration-encryption-rest.policytest.hcl... running
      # resource.aws_emr_security_configuration.pass_encryption_rest_enabled... running
      # resource.aws_emr_security_configuration.pass_encryption_rest_enabled... pass
      # resource.aws_emr_security_configuration.fail_encryption_rest_disabled... running
      # resource.aws_emr_security_configuration.fail_encryption_rest_disabled... pass
      # resource.aws_emr_security_configuration.fail_missing_encryption_rest... running
      # resource.aws_emr_security_configuration.fail_missing_encryption_rest... pass
      # resource.aws_emr_security_configuration.fail_missing_encryption_config... running
      # resource.aws_emr_security_configuration.fail_missing_encryption_config... pass
      # resource.aws_emr_security_configuration.pass_encryption_rest_with_transit... running
      # resource.aws_emr_security_configuration.pass_encryption_rest_with_transit... pass
      # emr-security-configuration-encryption-rest.policytest.hcl... pass
```

---
