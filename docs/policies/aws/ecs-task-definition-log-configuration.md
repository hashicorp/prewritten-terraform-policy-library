# ECS task definitions should have a logging configuration

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks if the latest active Amazon ECS task definition has a logging configuration specified. The control fails if the task definition doesn't have the logConfiguration property defined or if the value for logDriver is null in at least one container definition.

Logging helps you maintain the reliability, availability, and performance of Amazon ECS. Collecting data from task definitions provides visibility, which can help you debug processes and find the root cause of errors. If you are using a logging solution that does not have to be defined in the ECS task definition (such as a third party logging solution), you can disable this control after ensuring that your logs are properly captured and delivered.

This rule is covered by the [ecs-task-definition-log-configuration](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ecs/ecs-task-definition-log-configuration.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecs-task-definition-log-configuration.policytest.hcl... running
      # resource.aws_ecs_task_definition.single_container_with_logging... running
      # resource.aws_ecs_task_definition.single_container_with_logging... pass
      # resource.aws_ecs_task_definition.single_container_missing_log_configuration... running
      # resource.aws_ecs_task_definition.single_container_missing_log_configuration... pass
      # resource.aws_ecs_task_definition.single_container_empty_log_driver... running
      # resource.aws_ecs_task_definition.single_container_empty_log_driver... pass
      # resource.aws_ecs_task_definition.multiple_containers_all_with_logging... running
      # resource.aws_ecs_task_definition.multiple_containers_all_with_logging... pass
      # resource.aws_ecs_task_definition.multiple_containers_one_missing_log_configuration... running
      # resource.aws_ecs_task_definition.multiple_containers_one_missing_log_configuration... pass
      # ecs-task-definition-log-configuration.policytest.hcl... pass
```

---
