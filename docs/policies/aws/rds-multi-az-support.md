# RDS DB instances should be configured with multiple Availability Zones

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether high availability is enabled for your RDS DB instances. The control fails if an RDS DB instance isn't configured with multiple Availability Zones (AZs). This control doesn't apply to RDS DB instances that are part of a Multi-AZ DB cluster deployment.

Configuring Amazon RDS DB instances with AZs helps ensure the availability of stored data. Multi-AZ deployments allow for automated failover if there is an issue with AZ availability and during regular RDS maintenance.

This rule is covered by the [rds-multi-az-support](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-multi-az-support.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-multi-az-support.policytest.hcl... running
      # resource.aws_db_instance.pass_multi_az_true... running
      # resource.aws_db_instance.pass_multi_az_true... pass
      # resource.aws_db_instance.fail_multi_az_false... running
      # resource.aws_db_instance.fail_multi_az_false... pass
      # resource.aws_db_instance.fail_multi_az_missing... running
      # resource.aws_db_instance.fail_multi_az_missing... pass
      # rds-multi-az-support.policytest.hcl... pass
```

---
