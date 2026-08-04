# DMS replication instances should be configured to use multiple Availability Zones

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether an AWS Database Migration Service (AWS DMS) replication instance is configured to use multiple Availability Zones (Multi-AZ deployment). The control fails if the AWS DMS replication instance isn't configured to use a Multi-AZ deployment.

In a Multi-AZ deployment, AWS DMS automatically provisions and maintains a standby replica of a replication instance in a different Availability Zone (AZ). The primary replication instance is then synchronously replicated to the standby replica. If the primary replication instance fails or becomes unresponsive, the standby resumes any running tasks with minimal interruption. For more information, see Working with a replication instance in the AWS Database Migration Service User Guide.

This rule is covered by the [dms-replication-instance-multi-az-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/dms/dms-replication-instance-multi-az-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # dms-replication-instance-multi-az-enabled.policytest.hcl... running
      # resource.aws_dms_replication_instance.pass_multi_az_true... running
      # resource.aws_dms_replication_instance.pass_multi_az_true... pass
      # resource.aws_dms_replication_instance.fail_multi_az_false... running
      # resource.aws_dms_replication_instance.fail_multi_az_false... pass
      # resource.aws_dms_replication_instance.fail_multi_az_missing... running
      # resource.aws_dms_replication_instance.fail_multi_az_missing... pass
      # dms-replication-instance-multi-az-enabled.policytest.hcl... pass
```

---
