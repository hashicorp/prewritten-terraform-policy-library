# Copyright IBM Corp. 2026

# ECR repositories should have at least one lifecycle policy configured

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "ecr-private-lifecycle-policy-configured-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_ecr_repository" "lifecycle_policy_required" {
  enforcement_level = input.ecr-private-lifecycle-policy-configured-enforcement-level

  connected "aws_ecr_lifecycle_policy" {
    connection {
      subject = "name"
      target  = "repository"
    }

    cardinality = {
      min_matches = 1
      error_message = "ECR repository must have at least one lifecycle policy configured. Add an 'aws_ecr_lifecycle_policy' resource that references this repository to enable automated image cleanup and comply with ECR.3"
    }
  }
}
