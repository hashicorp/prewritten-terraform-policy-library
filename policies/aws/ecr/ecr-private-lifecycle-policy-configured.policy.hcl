# Copyright IBM Corp. 2026

# Policy: ECR.3 - ECR repositories should have at least one lifecycle policy configured

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "ecr-private-lifecycle-policy-configured-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_ecr_repository" "lifecycle_policy_required" {
  enforcement_level = input.ecr-private-lifecycle-policy-configured-enforcement-level

  connected "aws_ecr_lifecycle_policy" {
    min_instances = 1

    connection {
      subject   = "name"
      connected = "repository"
    }
  }
}
