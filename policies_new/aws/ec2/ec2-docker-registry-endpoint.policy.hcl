# Copyright IBM Corp. 2026

# VPCs should be configured with an interface endpoint for Docker Registry

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "ec2-docker-registry-endpoint-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_vpc" "docker_registry_endpoint_required" {
  enforcement_level = input.ec2-docker-registry-endpoint-enforcement-level
  filter = core::try(attrs.id, "") != ""

  locals {
    service_name = "ecr.dkr"
    service_pattern = "^com\\.amazonaws(-us-gov|\\.cn)?\\.[a-zA-Z0-9-]+\\.${local.service_name}(-fips)?$"
  }

  # for_each over a single-element local list — one iteration per required service.
  # where filters to Interface endpoints only (literal equality, Decision 7 Option A).
  # cardinality asserts at least one Interface endpoint exists for this service.
  # enforce checks self.service_name against the regex pattern for this iteration.
  connected "aws_vpc_endpoint" {
    for_each = [local.service_pattern]

    connection {
      reverse = true
      subject = "vpc_id"
      target  = "id"
    }

    where {
      vpc_endpoint_type = "Interface"
    }

    cardinality = {
      min_matches   = 1
      error_message = "VPC must have an Interface VPC endpoint for Amazon ECR Docker Registry (e.g. 'com.amazonaws.<region>.ecr.dkr')"
    }

    enforce {
      condition     = core::length(core::regexall(each.value, core::try(self.service_name, ""))) > 0
      error_message = "VPC endpoint ${self.id} (service '${self.service_name}') does not match the required pattern for '${local.service_name}'"
    }
  }
}
