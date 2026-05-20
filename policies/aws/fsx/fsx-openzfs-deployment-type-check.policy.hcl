# FSx.3 - FSx for OpenZFS file systems should be configured for Multi-AZ deployment.

policy {}

resource_policy "aws_fsx_openzfs_file_system" "openzfs_multi_az_deployment" {
    locals {
        deployment_type = core::try(attrs.deployment_type, "")
    }

    enforce {
        condition = local.deployment_type == "MULTI_AZ_1"
        error_message = "FSx for OpenZFS file system is not configured for Multi-AZ deployment. Set deployment_type = 'MULTI_AZ_1' for high availability and durability in production workloads. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/fsx-controls.html#fsx-3 for more details."
    }
}
