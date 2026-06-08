# Copyright IBM Corp. 2026

# EKS.8 - EKS clusters should have audit logging enabled.

policy {}

input "eks_log_types" {
    type = string
    default = ""
}

resource_policy "aws_eks_cluster" "audit_logging_enabled" {
    locals {
        enabled_log_types = core::try(attrs.enabled_cluster_log_types, [])
        audit_enabled = core::contains(local.enabled_log_types, "audit")
        valid_input = core::contains(core::split(",", input.eks_log_types), "audit")
        input_logs_not_enabled = local.valid_input ? core::contain([
            for type in input.eks_log_types : core::contains(local.enabled_log_types, type)
        ], false) : false
        input_condition = input.eks_log_types != "" ? local.input_logs_not_enabled : true
    }

    enforce {
        condition = local.audit_enabled && local.input_condition
        error_message = "EKS cluster does not have audit logging enabled. Add 'audit' to the 'enabled_cluster_log_types' list to enable audit logging for security and compliance monitoring. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/eks-controls.html#eks-8 for more details."
    }
}
