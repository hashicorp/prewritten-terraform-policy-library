# RabbitMQ brokers should use cluster deployment mode

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether the deployment mode for an Amazon MQ RabbitMQ broker is set to cluster deployment. The control fails if a single-instance broker (enabled by default) is set as the deployment mode.

Cluster deployment provides high availability for your Amazon MQ RabbitMQ brokers in an AWS Region. The cluster deployment is a logical grouping of three RabbitMQ broker nodes, each with its own Amazon Elastic Block Store (Amazon EBS) volume and a shared state. The cluster deployment ensures that data is replicated to all nodes in the cluster, which can reduce downtime and loss of data in the event of a failure.

This rule is covered by the [mq-rabbit-brokers-should-use-cluster-deployment](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/mq/mq-rabbit-brokers-should-use-cluster-deployment.policy.hcl) policy.

## Policy Results

```bash
trace:
      # mq-rabbit-brokers-should-use-cluster-deployment.policytest.hcl... running
      # resource.aws_mq_broker.rabbit_cluster_pass... running
      # resource.aws_mq_broker.rabbit_cluster_pass... pass
      # resource.aws_mq_broker.rabbit_single_fail... running
      # resource.aws_mq_broker.rabbit_single_fail... pass
      # resource.aws_mq_broker.rabbit_unset_fail... running
      # resource.aws_mq_broker.rabbit_unset_fail... pass
      # resource.aws_mq_broker.rabbit_null_fail... running
      # resource.aws_mq_broker.rabbit_null_fail... pass
      # resource.aws_mq_broker.rabbit_active_standby_fail... running
      # resource.aws_mq_broker.rabbit_active_standby_fail... pass
      # resource.aws_mq_broker.activemq_single_pass... running
      # resource.aws_mq_broker.activemq_single_pass... pass
      # resource.aws_mq_broker.activemq_unset_pass... running
      # resource.aws_mq_broker.activemq_unset_pass... pass
      # resource.aws_mq_broker.activemq_active_standby_pass... running
      # resource.aws_mq_broker.activemq_active_standby_pass... pass
      # mq-rabbit-brokers-should-use-cluster-deployment.policytest.hcl... pass
```

---