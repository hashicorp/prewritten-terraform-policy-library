# Secrets should not be passed as container environment variables

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Credentials not hard-coded |

## Description

This control checks if the key value of any variables in the environment parameter of container definitions includes AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, or ECS_ENGINE_AUTH_DATA. This control fails if a single environment variable in any container definition equals AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, or ECS_ENGINE_AUTH_DATA. This control does not cover environmental variables passed in from other locations such as Amazon S3. This control only evaluates the latest active revision of an Amazon ECS task definition.

AWS Systems Manager Parameter Store can help you improve the security posture of your organization. We recommend using the Parameter Store to store secrets and credentials instead of directly passing them into your container instances or hard coding them into your code.

This rule is covered by the [ecs-no-environment-secrets](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ecs/ecs-no-environment-secrets.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecs-no-environment-secrets.policytest.hcl... running
      # resource.aws_ecs_task_definition.pass_no_env_vars... running
      # resource.aws_ecs_task_definition.pass_no_env_vars... pass
      # resource.aws_ecs_task_definition.pass_safe_env_vars... running
      # resource.aws_ecs_task_definition.pass_safe_env_vars... pass
      # resource.aws_ecs_task_definition.pass_using_secrets... running
      # resource.aws_ecs_task_definition.pass_using_secrets... pass
      # resource.aws_ecs_task_definition.fail_aws_access_key_id... running
      # resource.aws_ecs_task_definition.fail_aws_access_key_id... pass
      # resource.aws_ecs_task_definition.fail_aws_secret_access_key... running
      # resource.aws_ecs_task_definition.fail_aws_secret_access_key... pass
      # resource.aws_ecs_task_definition.fail_ecs_engine_auth_data... running
      # resource.aws_ecs_task_definition.fail_ecs_engine_auth_data... pass
      # resource.aws_ecs_task_definition.fail_multiple_prohibited... running
      # resource.aws_ecs_task_definition.fail_multiple_prohibited... pass
      # resource.aws_ecs_task_definition.fail_multiple_containers... running
      # resource.aws_ecs_task_definition.fail_multiple_containers... pass
      # ecs-no-environment-secrets.policytest.hcl... pass
```

---
