# ECS Task Definitions should use in-transit encryption for EFS volumes

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether the latest active revision of an Amazon ECS task definition uses in-transit encryption for EFS volumes. The control fails if the latest active revision of the ECS task definition has in-transit encryption disabled for EFS volumes.

Amazon EFS volumes provide simple, scalable, and persistent shared file storage for use with your Amazon ECS tasks. Amazon EFS supports encryption of data in transit with Transport Layer Security (TLS). When encryption of data in transit is declared as a mount option for your EFS file system, Amazon EFS establishes a secure TLS connection with your EFS file system upon mounting your file system.

This rule is covered by the [ecs-task-definition-efs-encryption-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ecs/ecs-task-definition-efs-encryption-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecs-task-definition-efs-encryption-enabled.policytest.hcl... running
      # resource.aws_ecs_task_definition.pass_efs_encryption_enabled... running
      # resource.aws_ecs_task_definition.pass_efs_encryption_enabled... pass
      # resource.aws_ecs_task_definition.fail_efs_encryption_disabled... running
      # resource.aws_ecs_task_definition.fail_efs_encryption_disabled... pass
      # resource.aws_ecs_task_definition.fail_efs_encryption_not_specified... running
      # resource.aws_ecs_task_definition.fail_efs_encryption_not_specified... pass
      # resource.aws_ecs_task_definition.pass_multiple_efs_all_encrypted... running
      # resource.aws_ecs_task_definition.pass_multiple_efs_all_encrypted... pass
      # resource.aws_ecs_task_definition.fail_multiple_efs_one_disabled... running
      # resource.aws_ecs_task_definition.fail_multiple_efs_one_disabled... pass
      # resource.aws_ecs_task_definition.pass_no_efs_volumes... running
      # resource.aws_ecs_task_definition.pass_no_efs_volumes... pass
      # resource.aws_ecs_task_definition.pass_no_volumes... running
      # resource.aws_ecs_task_definition.pass_no_volumes... pass
      # ecs-task-definition-efs-encryption-enabled.policytest.hcl... pass
```

---
