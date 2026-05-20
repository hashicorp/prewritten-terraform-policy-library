# EKS.1 - EKS cluster endpoints should not be publicly accessible.

policy {}

resource_policy "aws_eks_cluster" "endpoint_no_public_access" {
    locals {
        vpc_config = core::try(attrs.vpc_config, []) != [] ? attrs.vpc_config[0] : null
    }

    enforce {
        condition = core::try(attrs.vpc_config, []) != [] && core::try(local.vpc_config.endpoint_public_access, true) == false
        error_message = "EKS cluster is either missing required 'vpc_config' block or has a publicly accessible endpoint. The vpc_config block must be defined with 'endpoint_public_access = false' to ensure the cluster endpoint is not publicly accessible. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/eks-controls.html#eks-1 for more details."
    }
}
