# Amazon Connect instances should have CloudWatch logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon Connect instance is configured to generate and store flow logs in an Amazon CloudWatch log group. The control fails if the Amazon Connect instance isn't configured to generate and store flow logs in a CloudWatch log group.

Amazon Connect flow logs provide real-time details about events in Amazon Connect flows. A flow defines the customer experience with an Amazon Connect contact center from start to finish. By default, when you create a new Amazon Connect instance, an Amazon CloudWatch log group is created automatically to store flow logs for the instance. Flow logs can help you analyze flows, find errors, and monitor operational metrics. You can also set up alerts for specific events that can occur in a flow.

This rule is covered by the [connect-instance-logging-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/connect/connect-instance-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # connect-instance-logging-enabled.policytest.hcl...
      running
      # resource.aws_connect_instance.pass_logging_enabled...
      running
      # resource.aws_connect_instance.pass_logging_enabled...
      pass
      # resource.aws_connect_instance.fail_logging_disabled...
      running
      # resource.aws_connect_instance.fail_logging_disabled...
      pass
      # resource.aws_connect_instance.fail_logging_not_specified...
      running
      # resource.aws_connect_instance.fail_logging_not_specified...
      pass
      # connect-instance-logging-enabled.policytest.hcl...
      pass
```

---
