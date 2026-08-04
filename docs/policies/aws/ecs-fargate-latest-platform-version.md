# ECS Fargate services should run on the latest Fargate platform version

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control checks if Amazon ECS Fargate services are running the latest Fargate platform version. This control fails if the platform version is not the latest.

AWS Fargate platform versions refer to a specific runtime environment for Fargate task infrastructure, which is a combination of kernel and container runtime versions. New platform versions are released as the runtime environment evolves. For example, a new version may be released for kernel or operating system updates, new features, bug fixes, or security updates. Security updates and patches are deployed automatically for your Fargate tasks. If a security issue is found that affects a platform version, AWS patches the platform version.

This rule is covered by the [ecs-fargate-latest-platform-version](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ecs/ecs-fargate-latest-platform-version.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecs-fargate-latest-platform-version.policytest.hcl... running
      # resource.aws_ecs_service.pass_latest_version... running
      # resource.aws_ecs_service.pass_latest_version... pass
      # resource.aws_ecs_service.pass_default_latest... running
      # resource.aws_ecs_service.pass_default_latest... pass
      # resource.aws_ecs_service.pass_explicit_linux_latest... running
      # resource.aws_ecs_service.pass_explicit_linux_latest... pass
      # resource.aws_ecs_service.pass_explicit_windows_latest... running
      # resource.aws_ecs_service.pass_explicit_windows_latest... pass
      # resource.aws_ecs_service.fail_old_version_1_3_0... running
      # resource.aws_ecs_service.fail_old_version_1_3_0... pass
      # resource.aws_ecs_service.fail_old_version_1_2_0... running
      # resource.aws_ecs_service.fail_old_version_1_2_0... pass
      # resource.aws_ecs_service.skip_ec2_launch_type... running
      # resource.aws_ecs_service.skip_ec2_launch_type... pass
      # ecs-fargate-latest-platform-version.policytest.hcl... pass
```

---
