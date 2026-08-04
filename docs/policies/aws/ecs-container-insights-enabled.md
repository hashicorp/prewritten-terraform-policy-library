# ECS clusters should use Container Insights

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks if ECS clusters use Container Insights. This control fails if Container Insights are not set up for a cluster.

Monitoring is an important part of maintaining the reliability, availability, and performance of Amazon ECS clusters. Use CloudWatch Container Insights to collect, aggregate, and summarize metrics and logs from your containerized applications and microservices. CloudWatch automatically collects metrics for many resources, such as CPU, memory, disk, and network. Container Insights also provides diagnostic information, such as container restart failures, to help you isolate issues and resolve them quickly. You can also set CloudWatch alarms on metrics that Container Insights collects.

This rule is covered by the [ecs-container-insights-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ecs/ecs-container-insights-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecs-container-insights-enabled.policytest.hcl... running
      # resource.aws_ecs_cluster.container_insights_enabled... running
      # resource.aws_ecs_cluster.container_insights_enabled... pass
      # resource.aws_ecs_cluster.container_insights_enhanced... running
      # resource.aws_ecs_cluster.container_insights_enhanced... pass
      # resource.aws_ecs_cluster.missing_container_insights_setting... running
      # resource.aws_ecs_cluster.missing_container_insights_setting... pass
      # resource.aws_ecs_cluster.container_insights_disabled... running
      # resource.aws_ecs_cluster.container_insights_disabled... pass
      # ecs-container-insights-enabled.policytest.hcl... pass
```

---
