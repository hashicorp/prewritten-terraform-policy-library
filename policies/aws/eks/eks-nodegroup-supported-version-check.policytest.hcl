# Copyright IBM Corp. 2026

policytest {
    targets = [
        "eks-nodegroup-supported-version-check.policy.hcl"
    ]
}

# Test 1: PASS - EKS node group is running a supported Kubernetes version
resource "aws_eks_node_group" "pass_ng_supported_version" {
    attrs = {
        cluster_name = "example-cluster-supported"
        node_group_name = "example"
        node_role_arn = "arn:aws:iam::123456789012:role/eks-cluster-role"
    }
}

resource "aws_eks_cluster" "example_cluster_supported" {
    skip = true
    attrs = {
        name = "example-cluster-supported"
        version = "1.33"
    }
}

# Test 2: FAIL - EKS node group is running an unsupported Kubernetes version
resource "aws_eks_node_group" "fail_ng_unsupported_version" {
    expect_failure = true
    attrs = {
        cluster_name = "example-cluster-unsupported"
        node_group_name = "example"
        node_role_arn = "arn:aws:iam::123456789012:role/eks-cluster-role"
    }
}

resource "aws_eks_cluster" "example_cluster_unsupported" {
    skip = true
    attrs = {
        name = "example-cluster-unsupported"
        version = "1.30"
    }
}

# Test 3: PASS - EKS node group is running a higher version than minimum supported
resource "aws_eks_node_group" "pass_ng_higher_version" {
    attrs = {
        cluster_name = "example-cluster-higher"
        node_group_name = "example"
        node_role_arn = "arn:aws:iam::123456789012:role/eks-cluster-role"
    }
}

resource "aws_eks_cluster" "example_cluster_higher" {
    skip = true
    attrs = {
        name = "example-cluster-higher"
        version = "1.35"
    }
}

# Test 4: PASS - Preserve the existing fallback when the cluster is unresolved
resource "aws_eks_node_group" "pass_ng_unresolved_cluster" {
    attrs = {
        cluster_name = "unresolved-cluster"
        node_group_name = "example"
        node_role_arn = "arn:aws:iam::123456789012:role/eks-cluster-role"
    }
}
