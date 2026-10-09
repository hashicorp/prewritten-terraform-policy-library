# Neptune DB clusters should be deployed across multiple Availability Zones

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks if an Amazon Neptune DB cluster has read-replica instances in multiple Availability Zones (AZs). The control fails if the cluster is deployed in only one AZ.

If an AZ is unavailable and during regular maintenance events, read-replicas serve as failover targets for the primary instance. That is, if the primary instance fails, Neptune promotes a read-replica instance to become the primary instance. By contrast, if your DB cluster doesn't include any read-replica instances, your DB cluster remains unavailable when the primary instance fails until it has been re-created. Re-creating the primary instance takes considerably longer than promoting a read-replica. To ensure high availability, we recommend that you create one or more read-replica instances that have the same DB instance class as the primary instance and are located in different AZs than the primary instance.

This rule is covered by the [neptune-cluster-should-be-deployed-in-multi-az](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/neptune/neptune-cluster-should-be-deployed-in-multi-az.policy.hcl) policy.

## Policy Results

```bash
trace:
      # neptune-cluster-should-be-deployed-in-multi-az.policytest.hcl... running
      # resource.aws_neptune_cluster.pass_two_azs... running
      # resource.aws_neptune_cluster.pass_two_azs... pass
      # resource.aws_neptune_cluster.pass_three_azs... running
      # resource.aws_neptune_cluster.pass_three_azs... pass
      # resource.aws_neptune_cluster.fail_one_az... running
      # resource.aws_neptune_cluster.fail_one_az... pass
      # resource.aws_neptune_cluster.fail_empty_azs... running
      # resource.aws_neptune_cluster.fail_empty_azs... pass
      # resource.aws_neptune_cluster.fail_missing_azs... running
      # resource.aws_neptune_cluster.fail_missing_azs... pass
      # resource.aws_neptune_cluster.fail_null_azs... running
      # resource.aws_neptune_cluster.fail_null_azs... pass
      # neptune-cluster-should-be-deployed-in-multi-az.policytest.hcl... pass
```

---