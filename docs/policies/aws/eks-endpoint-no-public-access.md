# EKS cluster endpoints should not be publicly accessible

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether an Amazon EKS cluster endpoint is publicly accessible. The control fails if an EKS cluster has an endpoint that is publicly accessible.

When you create a new cluster, Amazon EKS creates an endpoint for the managed Kubernetes API server that you use to communicate with your cluster. By default, this API server endpoint is publicly available to the internet. Access to the API server is secured using a combination of AWS Identity and Access Management (IAM) and native Kubernetes Role Based Access Control (RBAC). By removing public access to the endpoint, you can avoid unintentional exposure and access to your cluster.

This rule is covered by the [eks-endpoint-no-public-access](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/eks/eks-endpoint-no-public-access.policy.hcl) policy.

## Policy Results

```bash
trace:
      # eks-endpoint-no-public-access.policytest.hcl... running
      # resource.aws_eks_cluster.pass_public_access_disabled... running
      # resource.aws_eks_cluster.pass_public_access_disabled... pass
      # resource.aws_eks_cluster.fail_public_access_enabled... running
      # resource.aws_eks_cluster.fail_public_access_enabled... pass
      # resource.aws_eks_cluster.fail_public_access_default... running
      # resource.aws_eks_cluster.fail_public_access_default... pass
      # resource.aws_eks_cluster.fail_missing_vpc_config... running
      # resource.aws_eks_cluster.fail_missing_vpc_config... pass
      # resource.aws_eks_cluster.fail_empty_vpc_config... running
      # resource.aws_eks_cluster.fail_empty_vpc_config... pass
      # eks-endpoint-no-public-access.policytest.hcl... pass
```

---
