# Copyright IBM Corp. 2026

# EKS cluster endpoints should not be publicly accessible

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "eks-endpoint-no-public-access-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_eks_cluster" "endpoint_no_public_access" {
    enforcement_level = input.eks-endpoint-no-public-access-enforcement-level
    locals {
        vpc_config_raw = core::try(attrs.vpc_config, [])
        has_vpc_config = core::length(local.vpc_config_raw) > 0
        vpc_config     = local.has_vpc_config ? local.vpc_config_raw[0] : null
    }

    enforce {
        condition = local.has_vpc_config && (core::try(local.vpc_config.endpoint_public_access, null) != null ? local.vpc_config.endpoint_public_access : true) == false
        error_message = "EKS cluster is either missing required 'vpc_config' block or has a publicly accessible endpoint. The vpc_config block must be defined with 'endpoint_public_access = false' to ensure the cluster endpoint is not publicly accessible"
    }
}
