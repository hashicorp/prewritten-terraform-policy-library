# Copyright IBM Corp. 2026

# SageMaker.2 - SageMaker notebook instances should be launched in a custom VPC.

policy {}

resource_policy "aws_sagemaker_notebook_instance" "custom_vpc_required" {
    locals {
        # Check if subnet_id is configured
        # The presence of subnet_id indicates the notebook is in a custom VPC
        # Absence means it's using the default SageMaker service VPC
        subnet_id_value = core::try(attrs.subnet_id, "")
    }

    enforce {
        condition = local.subnet_id_value != ""
        error_message = "SageMaker notebook instance must be launched in a custom VPC. Configure the 'subnet_id' attribute to specify a VPC subnet. The absence of 'subnet_id' means the instance will use the SageMaker service VPC, which violates this security control. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/sagemaker-controls.html#sagemaker-2 for more details."
    }
}
