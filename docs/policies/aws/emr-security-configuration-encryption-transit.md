# Amazon EMR security configurations should be encrypted in transit

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an Amazon EMR security configuration has encryption in transit enabled. The control fails if the security configuration doesn't enable encryption in transit.

Data in transit refers to data that moves from one location to another, such as between nodes in your cluster or between your cluster and your application. Data may move across the internet or within a private network. Encrypting data in transit reduces the risk that an unauthorized user can eavesdrop on network traffic.

This rule is covered by the [emr-security-configuration-encryption-transit](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/emr/emr-security-configuration-encryption-transit.policy.hcl) policy.

## Policy Results

```bash
trace:
      # emr-security-configuration-encryption-transit.policytest.hcl... running
      # resource.aws_emr_security_configuration.pass_encryption_transit_enabled... running
      # resource.aws_emr_security_configuration.pass_encryption_transit_enabled... pass
      # resource.aws_emr_security_configuration.fail_encryption_transit_disabled... running
      # resource.aws_emr_security_configuration.fail_encryption_transit_disabled... pass
      # resource.aws_emr_security_configuration.fail_missing_encryption_transit... running
      # resource.aws_emr_security_configuration.fail_missing_encryption_transit... pass
      # resource.aws_emr_security_configuration.fail_missing_encryption_config... running
      # resource.aws_emr_security_configuration.fail_missing_encryption_config... pass
      # resource.aws_emr_security_configuration.pass_encryption_transit_with_rest... running
      # resource.aws_emr_security_configuration.pass_encryption_transit_with_rest... pass
      # emr-security-configuration-encryption-transit.policytest.hcl... pass
```

---
