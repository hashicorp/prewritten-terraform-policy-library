# MSK clusters should have enhanced monitoring configured

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon MSK cluster has enhanced monitoring configured, specified by a monitoring level of at least PER_TOPIC_PER_BROKER. The control fails if the monitoring level for the cluster is set to DEFAULT or PER_BROKER.

The PER_TOPIC_PER_BROKER monitoring level provides more granular insights into the performance of your MSK cluster, and also provides metrics related to resource utilization, such as CPU and memory usage. This helps you identify performance bottlenecks and resource utilization patterns for individual topics and brokers. This visibility, in turn, can optimize the performance of your Kafka brokers.

This rule is covered by the [msk-clusters-should-have-enhanced-monitoring-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/msk/msk-clusters-should-have-enhanced-monitoring-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # msk-clusters-should-have-enhanced-monitoring-enabled.policytest.hcl... running
      # resource.aws_msk_cluster.pass_per_topic_per_broker... running
      # resource.aws_msk_cluster.pass_per_topic_per_broker... pass
      # resource.aws_msk_cluster.pass_per_topic_per_partition... running
      # resource.aws_msk_cluster.pass_per_topic_per_partition... pass
      # resource.aws_msk_cluster.fail_default... running
      # resource.aws_msk_cluster.fail_default... pass
      # resource.aws_msk_cluster.fail_per_broker... running
      # resource.aws_msk_cluster.fail_per_broker... pass
      # resource.aws_msk_cluster.fail_missing_enhanced_monitoring... running
      # resource.aws_msk_cluster.fail_missing_enhanced_monitoring... pass
      # resource.aws_msk_cluster.fail_null_enhanced_monitoring... running
      # resource.aws_msk_cluster.fail_null_enhanced_monitoring... pass
      # msk-clusters-should-have-enhanced-monitoring-enabled.policytest.hcl... pass
```

---