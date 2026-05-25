# Policy: ECS.20 - ECS Task Definitions should configure non-root users in Linux container definitions

policy {}

resource_policy "aws_ecs_task_definition" "ecs20_nonroot_user_linux" {
  # Only evaluate Linux task definitions.
  # operatingSystemFamily defaults to LINUX when runtime_platform is not specified,
  # so core::try falls back to "LINUX" if the attribute or nested field is absent.
  filter = core::try(attrs.runtime_platform[0].operating_system_family, "LINUX") == "LINUX"

  locals {
    # container_definitions attribute - access directly as structured data
    # In tfpolicy, this attribute is already parsed from JSON
    container_defs = core::try(attrs.container_definitions, [])
    
    # Check each container for user configuration
    container_checks = [
      for idx, container in local.container_defs : {
        name = container.name
        has_user = core::try(container.user, null) != null
        user_value = core::try(container.user, "")
        is_root = core::contains(["root", "0"], core::try(container.user, ""))
        is_compliant = (
          core::try(container.user, null) != null &&
          !core::contains(["root", "0"], core::try(container.user, ""))
        )
      }
    ]
    
    # Find containers without user configured
    containers_missing_user = [
      for check in local.container_checks :
      check.name if !check.has_user
    ]
    
    # Find containers configured as root
    containers_as_root = [
      for check in local.container_checks :
      check.name if check.has_user && check.is_root
    ]
    

  }

  # Enforce: All containers must have user parameter configured
  enforce {
    condition = core::length(local.containers_missing_user) == 0
    error_message = "ECS task definition has containers without 'user' parameter configured. All Linux containers must specify a non-root user following the principle of least privilege. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ecs-controls.html#ecs-20 for more details."
  }

  # Enforce: No containers should run as root
  enforce {
    condition = core::length(local.containers_as_root) == 0
    error_message = "ECS task definition has containers configured to run as root user. The 'user' parameter must not be 'root' or '0'. Use a non-root user (e.g., 'appuser', '1000', 'appuser:appgroup', '1000:1000'). Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ecs-controls.html#ecs-20 for more details."
  }
}
