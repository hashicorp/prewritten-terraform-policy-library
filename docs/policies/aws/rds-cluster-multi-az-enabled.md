# RDS DB clusters should be configured for multiple Availability Zones

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether high availability is enabled for your RDS DB clusters. The control fails if an RDS DB cluster isn't deployed in multiple Availability Zones (AZs).

RDS DB clusters should be configured for multiple AZs to ensure availability of stored data. Deployment to multiple AZs allows for automated failover in the event of an AZ availability issue and during regular RDS maintenance events.

This rule is covered by the [rds-cluster-multi-az-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-cluster-multi-az-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-cluster-multi-az-enabled.policytest.hcl... running
      # resource.aws_rds_cluster.aurora_cluster_with_2_azs_passes... running
      # resource.aws_rds_cluster.aurora_cluster_with_2_azs_passes... pass
      # resource.aws_rds_cluster.aurora_cluster_with_3_azs_passes... running
      # resource.aws_rds_cluster.aurora_cluster_with_3_azs_passes... pass
      # resource.aws_rds_cluster.multi_az_cluster_with_3_azs_passes... running
      # resource.aws_rds_cluster.multi_az_cluster_with_3_azs_passes... pass
      # resource.aws_rds_cluster.aurora_cluster_with_1_az_fails... running
      # resource.aws_rds_cluster.aurora_cluster_with_1_az_fails... pass
      # resource.aws_rds_cluster.aurora_cluster_with_empty_azs_fails... running
      # resource.aws_rds_cluster.aurora_cluster_with_empty_azs_fails... pass
      # resource.aws_rds_cluster.multi_az_cluster_with_2_azs_fails... running
      # resource.aws_rds_cluster.multi_az_cluster_with_2_azs_fails... pass
      # resource.aws_rds_cluster.cluster_without_azs_attribute_fails... running
      # resource.aws_rds_cluster.cluster_without_azs_attribute_fails... pass
      # rds-cluster-multi-az-enabled.policytest.hcl... pass
```

---
