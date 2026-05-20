# EKS clusters should use encrypted Kubernetes secrets

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether an Amazon EKS cluster uses encrypted Kubernetes secrets. The control fails if the cluster's Kubernetes secrets aren't encrypted.

When you encrypt secrets, you can use AWS Key Management Service (AWS KMS) keys to provide envelope encryption of Kubernetes secrets stored in etcd for your cluster. This encryption is in addition to the EBS volume encryption that is enabled by default for all data (including secrets) that is stored in etcd as part of an EKS cluster. Using secrets encryption for your EKS cluster allows you to deploy a defense in depth strategy for Kubernetes applications by encrypting Kubernetes secrets with a KMS key that you define and manage.

This rule is covered by the [eks-cluster-secrets-encrypted](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/eks/eks-cluster-secrets-encrypted.policy.hcl) policy.

## Policy Results

```bash
trace:
      # eks-cluster-secrets-encrypted.policytest.hcl... running
      # resource.aws_eks_cluster.pass_with_complete_encryption_config... running
      # resource.aws_eks_cluster.pass_with_complete_encryption_config... pass
      # resource.aws_eks_cluster.fail_without_encryption_config... running
      # resource.aws_eks_cluster.fail_without_encryption_config... pass
      # resource.aws_eks_cluster.fail_without_key_arn... running
      # resource.aws_eks_cluster.fail_without_key_arn... pass
      # resource.aws_eks_cluster.fail_secrets_not_in_resources... running
      # resource.aws_eks_cluster.fail_secrets_not_in_resources... pass
      # resource.aws_eks_cluster.fail_empty_resources_list... running
      # resource.aws_eks_cluster.fail_empty_resources_list... pass
      # resource.aws_eks_cluster.pass_with_multiple_encrypted_resources... running
      # resource.aws_eks_cluster.pass_with_multiple_encrypted_resources... pass
      # eks-cluster-secrets-encrypted.policytest.hcl... pass
```

---
