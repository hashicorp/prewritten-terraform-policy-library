# ECS services should not have public IP addresses assigned to them automatically

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether Amazon ECS services are configured to automatically assign public IP addresses. This control fails if AssignPublicIP is ENABLED. This control passes if AssignPublicIP is DISABLED.

A public IP address is an IP address that is reachable from the internet. If you launch your Amazon ECS instances with a public IP address, then your Amazon ECS instances are reachable from the internet. Amazon ECS services should not be publicly accessible, as this may allow unintended access to your container application servers.

This rule is covered by the [ecs-service-assign-public-ip-disabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ecs/ecs-service-assign-public-ip-disabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ecs-service-assign-public-ip-disabled.policytest.hcl... running
      # resource.aws_ecs_service.pass_explicit_false... running
      # resource.aws_ecs_service.pass_explicit_false... pass
      # resource.aws_ecs_service.pass_default_false... running
      # resource.aws_ecs_service.pass_default_false... pass
      # resource.aws_ecs_service.pass_no_network_config... running
      # resource.aws_ecs_service.pass_no_network_config... pass
      # resource.aws_ecs_service.fail_public_ip_enabled... running
      # resource.aws_ecs_service.fail_public_ip_enabled... pass
      # ecs-service-assign-public-ip-disabled.policytest.hcl... pass
```

---
