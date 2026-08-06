# Application and Classic Load Balancers logging should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether the Application Load Balancer and the Classic Load Balancerhave logging enabled. The control fails if access_logs.s3.enabled is false.

Elastic Load Balancing provides access logs that capture detailed information about requests sent to your load balancer. Each log contains information such as the time the request was received, the client's IP address, latencies, request paths, and server responses. You can use these access logs to analyze traffic patterns and to troubleshoot issues.

To learn more, see Access logs for your Classic Load Balancer in User Guide for Classic Load Balancers.

This rule is covered by the [elb-logging-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elb/elb-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elb-logging-enabled.policytest.hcl... running
      # resource.aws_elb.pass_with_enabled_true... running
      # resource.aws_elb.pass_with_enabled_true... pass
      # resource.aws_elb.pass_with_enabled_default... running
      # resource.aws_elb.pass_with_enabled_default... pass
      # resource.aws_elb.fail_with_enabled_false... running
      # resource.aws_elb.fail_with_enabled_false... pass
      # resource.aws_elb.fail_without_access_logs... running
      # resource.aws_elb.fail_without_access_logs... pass
      # resource.aws_elb.fail_with_null_access_logs... running
      # resource.aws_elb.fail_with_null_access_logs... pass
      # resource.aws_lb.pass_application_lb_with_enabled_true... running
      # resource.aws_lb.pass_application_lb_with_enabled_true... pass
      # resource.aws_lb.fail_application_lb_with_enabled_false... running
      # resource.aws_lb.fail_application_lb_with_enabled_false... pass
      # resource.aws_lb.fail_application_lb_without_access_logs... running
      # resource.aws_lb.fail_application_lb_without_access_logs... pass
      # resource.aws_lb.fail_application_lb_with_bucket_but_no_enabled... running
      # resource.aws_lb.fail_application_lb_with_bucket_but_no_enabled... pass
      # resource.aws_lb.skip_network_load_balancer... running
      # resource.aws_lb.skip_network_load_balancer... pass
      # resource.aws_lb.pass_application_lb_default_type... running
      # resource.aws_lb.pass_application_lb_default_type... pass
      # elb-logging-enabled.policytest.hcl... pass
```

---
