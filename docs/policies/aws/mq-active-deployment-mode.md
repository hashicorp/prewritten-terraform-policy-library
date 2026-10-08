# ActiveMQ brokers should use active/standby deployment mode

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether the deployment mode for an Amazon MQ ActiveMQ broker is set to active/standby. The control fails if a single-instance broker (enabled by default) is set as the deployment mode.

Active/standby deployment provides high availability for your Amazon MQ ActiveMQ brokers in an AWS Region. The active/standby deployment mode includes two broker instances in two different Availability Zones, configured in a redundant pair. These brokers communicate synchronously with your application, which can reduce downtime and loss of data in the event of a failure.

This rule is covered by the [mq-active-deployment-mode](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/mq/mq-active-deployment-mode.policy.hcl) policy.

## Policy Results

```bash
trace:
      # mq-active-deployment-mode.policytest.hcl... running
      # resource.aws_mq_broker.pass_active_standby... running
      # resource.aws_mq_broker.pass_active_standby... pass
      # resource.aws_mq_broker.pass_cluster_multi_az... running
      # resource.aws_mq_broker.pass_cluster_multi_az... pass
      # resource.aws_mq_broker.fail_single_instance... running
      # resource.aws_mq_broker.fail_single_instance... pass
      # resource.aws_mq_broker.fail_deployment_mode_omitted... running
      # resource.aws_mq_broker.fail_deployment_mode_omitted... pass
      # resource.aws_mq_broker.fail_deployment_mode_null... running
      # resource.aws_mq_broker.fail_deployment_mode_null... pass
      # resource.aws_mq_broker.fail_empty_deployment_mode... running
      # resource.aws_mq_broker.fail_empty_deployment_mode... pass
      # mq-active-deployment-mode.policytest.hcl... pass
```

---