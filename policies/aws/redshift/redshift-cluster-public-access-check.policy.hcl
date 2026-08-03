# Copyright IBM Corp. 2026

# Redshift.1 - Amazon Redshift clusters should prohibit public access. This control checks whether Amazon Redshift clusters are publicly accessible.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "redshift-cluster-public-access-check-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_redshift_cluster" "public_access_check" {
    enforcement_level = input.redshift-cluster-public-access-check-enforcement-level
    enforce {
        condition = core::try(attrs.publicly_accessible, false) == false
        error_message = "Redshift cluster is publicly accessible. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshift-controls.html#redshift-1 for more details."
    }
}