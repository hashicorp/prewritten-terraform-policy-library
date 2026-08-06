# EKS clusters should run on a supported Kubernetes version

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control checks whether an Amazon Elastic Kubernetes Service (Amazon EKS) cluster is running on a standard support Kubernetes version. The control fails if the Amazon EKS cluster is running on an unsupported or extended support version.

If your application doesn't require a specific version of Kubernetes, we recommend that you use the latest available Kubernetes version that's supported by EKS for your clusters. For more information, see Amazon EKS Kubernetes release calendar and Understand the Kubernetes version lifecycle on Amazon EKS in the Amazon EKS User Guide.

This rule is covered by the [eks-cluster-supported-version](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/eks/eks-cluster-supported-version.policy.hcl) policy.

## Policy Results

```bash
trace:
      # eks-cluster-supported-version.policytest.hcl... running
      # resource.aws_eks_cluster.pass_supported_version... running
      # resource.aws_eks_cluster.pass_supported_version... pass
      # resource.aws_eks_cluster.fail_unsupported_version... running
      # resource.aws_eks_cluster.fail_unsupported_version... pass
      # resource.aws_eks_cluster.fail_no_version... running
      # resource.aws_eks_cluster.fail_no_version... pass
      # eks-cluster-supported-version.policytest.hcl... pass
```

---
