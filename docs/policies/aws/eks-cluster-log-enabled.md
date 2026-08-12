# EKS clusters should have audit logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon EKS cluster has audit logging enabled. The control fails if audit logging isn't enabled for the cluster.

This control doesn't check whether Amazon EKS audit logging is enabled through Amazon Security Lake for the AWS account.

EKS control plane logging provides audit and diagnostic logs directly from the EKS control plane to Amazon CloudWatch Logs in your account. You can select the log types you need, and logs are sent as log streams to a group for each EKS cluster in CloudWatch. Logging provides visibility into the access and performance of EKS clusters. By sending EKS control plane logs for your EKS clusters to CloudWatch Logs, you can record operations for audit and diagnostic purposes in a central location.

This rule is covered by the [eks-cluster-log-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/eks/eks-cluster-log-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # eks-cluster-log-enabled.policytest.hcl... running
      # resource.aws_eks_cluster.pass_with_audit_enabled... running
      # resource.aws_eks_cluster.pass_with_audit_enabled... pass
      # resource.aws_eks_cluster.pass_with_all_log_types... running
      # resource.aws_eks_cluster.pass_with_all_log_types... pass
      # resource.aws_eks_cluster.fail_without_audit... running
      # resource.aws_eks_cluster.fail_without_audit... pass
      # resource.aws_eks_cluster.fail_with_empty_log_types... running
      # resource.aws_eks_cluster.fail_with_empty_log_types... pass
      # resource.aws_eks_cluster.fail_without_log_types_attribute... running
      # resource.aws_eks_cluster.fail_without_log_types_attribute... pass
      # eks-cluster-log-enabled.policytest.hcl... pass
```

---
