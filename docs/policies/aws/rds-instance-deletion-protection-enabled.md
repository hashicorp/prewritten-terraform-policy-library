# RDS DB instances should have deletion protection enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Data deletion protection |

## Description

This control checks whether your RDS DB instances that use one of the listed database engines have deletion protection enabled. The control fails if an RDS DB instance doesn't have deletion protection enabled.

Enabling instance deletion protection is an additional layer of protection against accidental database deletion or deletion by an unauthorized entity.

While deletion protection is enabled, an RDS DB instance cannot be deleted. Before a deletion request can succeed, deletion protection must be disabled.

This rule is covered by the [rds-instance-deletion-protection-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-instance-deletion-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-instance-deletion-protection-enabled.policytest.hcl... running
      # resource.aws_db_instance.pass_deletion_protection... running
      # resource.aws_db_instance.pass_deletion_protection... pass
      # resource.aws_db_instance.fail_deletion_protection... running
      # resource.aws_db_instance.fail_deletion_protection... pass
      # resource.aws_db_instance.fail_deletion_protection_missing... running
      # resource.aws_db_instance.fail_deletion_protection_missing... pass
      # rds-instance-deletion-protection-enabled.policytest.hcl... pass
```

---
