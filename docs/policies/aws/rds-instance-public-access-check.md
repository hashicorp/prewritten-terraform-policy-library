# RDS DB Instances should prohibit public access, as determined by the PubliclyAccessible configuration

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether Amazon RDS instances are publicly accessible by evaluating the PubliclyAccessible field in the instance configuration item.

Neptune DB instances and Amazon DocumentDB clusters do not have the PubliclyAccessible flag and cannot be evaluated. However, this control can still generate findings for these resources. You can suppress these findings.

The PubliclyAccessible value in the RDS instance configuration indicates whether the DB instance is publicly accessible. When the DB instance is configured with PubliclyAccessible, it is an Internet-facing instance with a publicly resolvable DNS name, which resolves to a public IP address. When the DB instance isn't publicly accessible, it is an internal instance with a DNS name that resolves to a private IP address.

Unless you intend for your RDS instance to be publicly accessible, the RDS instance should not be configured with PubliclyAccessible value. Doing so might allow unnecessary traffic to your database instance.

This rule is covered by the [rds-instance-public-access-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-instance-public-access-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-instance-public-access-check.policytest.hcl... running
      # resource.aws_db_instance.pass_publicly_accessible_false... running
      # resource.aws_db_instance.pass_publicly_accessible_false... pass
      # resource.aws_db_instance.fail_publicly_accessible_true... running
      # resource.aws_db_instance.fail_publicly_accessible_true... pass
      # resource.aws_db_instance.fail_publicly_accessible_missing... running
      # resource.aws_db_instance.fail_publicly_accessible_missing... pass
      # rds-instance-public-access-check.policytest.hcl... pass
```

---
