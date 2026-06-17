# FSx.4 - FSx for NetApp ONTAP file systems should be configured for Multi-AZ deployment.

policy {}

input "fsx-ontap-deployment-type-check-enforcement-level" {
  type = string
  default = "advisory"
}

input "ontap_deployment_types" {
    type = string
    default = "MULTI_AZ_1,MULTI_AZ_2"
}

resource_policy "aws_fsx_ontap_file_system" "ontap_multi_az_deployment" {
    enforcement_level = input.fsx-ontap-deployment-type-check-enforcement-level
    locals {
        trimmed_input = core::trimspace(input.ontap_deployment_types)
        inputs = [for split in core::split(",", local.trimmed_input) : core::trimspace(split)]
        has_invalid_input = core::contains([
            for input in local.inputs: input == "MULTI_AZ_1" || input == "MULTI_AZ_2"
        ], false)
        deployment_type = core::try(attrs.deployment_type, "SINGLE_AZ_1")
    }

    enforce {
        condition = !local.has_invalid_input && core::contains(local.inputs, local.deployment_type)
        error_message = "FSx for NetApp ONTAP file system is not configured for Multi-AZ deployment. Set deployment_type = 'MULTI_AZ_1' or 'MULTI_AZ_2' for high availability and durability in production workloads. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/fsx-controls.html#fsx-4 for more details."
    }
}
