# FSx.5 - FSx for Windows File Server file systems should be configured for Multi-AZ deployment

policy {}

resource_policy "aws_fsx_windows_file_system" "multi_az_deployment" {
    locals {
        deployment_type = core::try(attrs.deployment_type, "SINGLE_AZ_1")
    }

    enforce {
        condition = local.deployment_type == "MULTI_AZ_1"
        error_message = "FSx for Windows File Server file system is not configured for Multi-AZ deployment. Set deployment_type = 'MULTI_AZ_1' for high availability and durability in production workloads. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/fsx-controls.html#fsx-5 for more details."
    }
}
