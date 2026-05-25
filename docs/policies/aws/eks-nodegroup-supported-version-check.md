# EKS node groups should run on a supported Kubernetes version

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control checks whether an Amazon EKS node group runs on a standard support Kubernetes version. The control fails if the Amazon EKS node group runs on an unsupported or extended support version.

Running EKS node groups on unsupported Kubernetes versions means those nodes no longer receive security patches, bug fixes, or compatibility updates from AWS. Unsupported versions may contain known vulnerabilities that have been addressed in newer releases, and they may experience compatibility issues with updated AWS services, container images, and third-party tools in the Kubernetes ecosystem. If your application doesn't require a specific version of Kubernetes, we recommend that you use the latest available Kubernetes version that's supported by Amazon EKS for your node groups. For more information, see Amazon EKS Kubernetes release calendar and Understand each phase of node updates in the Amazon EKS User Guide.

This rule is covered by the [eks-nodegroup-supported-version-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/eks/eks-nodegroup-supported-version-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # eks-nodegroup-supported-version-check.policytest.hcl... running
      # resource.aws_eks_node_group.pass_ng_supported_version... running
      # resource.aws_eks_node_group.pass_ng_supported_version... pass
      # resource.aws_eks_node_group.fail_ng_unsupported_version... running
      # resource.aws_eks_node_group.fail_ng_unsupported_version... pass
      # resource.aws_eks_node_group.pass_ng_higher_version... running
      # resource.aws_eks_node_group.pass_ng_higher_version... pass
      # eks-nodegroup-supported-version-check.policytest.hcl... pass
```

---
