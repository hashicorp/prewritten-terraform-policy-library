# RDS snapshot should be private

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether Amazon RDS snapshots are public. The control fails if RDS snapshots are public. This control evaluates RDS instances, Aurora DB instances, Neptune DB instances, and Amazon DocumentDB clusters.

RDS snapshots are used to back up the data on your RDS instances at a specific point in time. They can be used to restore previous states of RDS instances.

An RDS snapshot must not be public unless intended. If you share an unencrypted manual snapshot as public, this makes the snapshot available to all AWS accounts. This may result in unintended data exposure of your RDS instance.

Note that if the configuration is changed to allow public access, the AWS Config rule may not be able to detect the change for up to 12 hours. Until the AWS Config rule detects the change, the check passes even though the configuration violates the rule.

To learn more about sharing a DB snapshot, see Sharing a DB snapshot in the Amazon RDS User Guide.

This rule is covered by the [rds-snapshots-public-prohibited](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-snapshots-public-prohibited.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-snapshots-public-prohibited.policytest.hcl... running
      # resource.aws_db_snapshot.private_snapshot... running
      # resource.aws_db_snapshot.private_snapshot... pass
      # resource.aws_db_snapshot.shared_snapshot... running
      # resource.aws_db_snapshot.shared_snapshot... pass
      # resource.aws_db_snapshot.public_snapshot... running
      # resource.aws_db_snapshot.public_snapshot... pass
      # resource.aws_db_cluster_snapshot.private_cluster_snapshot... running
      # resource.aws_db_cluster_snapshot.private_cluster_snapshot... pass
      # resource.aws_db_cluster_snapshot.shared_cluster_snapshot... running
      # resource.aws_db_cluster_snapshot.shared_cluster_snapshot... pass
      # resource.aws_db_cluster_snapshot.public_cluster_snapshot... running
      # resource.aws_db_cluster_snapshot.public_cluster_snapshot... pass
      # resource.aws_db_snapshot.mixed_public_snapshot... running
      # resource.aws_db_snapshot.mixed_public_snapshot... pass
      # rds-snapshots-public-prohibited.policytest.hcl... pass
```

---
