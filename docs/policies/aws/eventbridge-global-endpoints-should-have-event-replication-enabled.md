# EventBridge global endpoints should have event replication enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks if event replication is enabled for an Amazon EventBridge global endpoint. The control fails if event replication isn't enabled for a global endpoint.

Global endpoints help make your application Regional-fault tolerant. To start, you assign an Amazon Route 53 health check to the endpoint. When failover is initiated, the health check reports an "unhealthy" state. Within minutes of failover initiation, all custom events are routed to an event bus in the secondary Region and are processed by that event bus. When you use global endpoints, you can enable event replication. Event replication sends all custom events to the event buses in the primary and secondary Regions using managed rules. We recommend enabling event replication when setting up global endpoints. Event replication helps you verify that your global endpoints are configured correctly. Event replication is required to automatically recover from a failover event. If you don’t have event replication enabled, you’ll have to manually reset the Route 53 health check to "healthy" before events are rerouted back to the primary Region.

This rule is covered by the [eventbridge-global-endpoints-should-have-event-replication-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/eventbridge/eventbridge-global-endpoints-should-have-event-replication-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # eventbridge-global-endpoints-should-have-event-replication-enabled.policytest.hcl... running
      # resource.aws_cloudwatch_event_endpoint.pass_enabled... running
      # resource.aws_cloudwatch_event_endpoint.pass_enabled... pass
      # resource.aws_cloudwatch_event_endpoint.fail_disabled... running
      # resource.aws_cloudwatch_event_endpoint.fail_disabled... pass
      # resource.aws_cloudwatch_event_endpoint.fail_no_replication_config... running
      # resource.aws_cloudwatch_event_endpoint.fail_no_replication_config... pass
      # resource.aws_cloudwatch_event_endpoint.fail_empty_replication_config... running
      # resource.aws_cloudwatch_event_endpoint.fail_empty_replication_config... pass
      # resource.aws_cloudwatch_event_endpoint.fail_null_state... running
      # resource.aws_cloudwatch_event_endpoint.fail_null_state... pass
      # resource.aws_cloudwatch_event_endpoint.fail_lowercase_state... running
      # resource.aws_cloudwatch_event_endpoint.fail_lowercase_state... pass
      # eventbridge-global-endpoints-should-have-event-replication-enabled.policytest.hcl... pass
```

---