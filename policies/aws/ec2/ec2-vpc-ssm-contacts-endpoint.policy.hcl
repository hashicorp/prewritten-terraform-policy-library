# Copyright IBM Corp. 2026

# Policy: EC2.58 - VPCs should be configured with an interface endpoint for Systems Manager Incident Manager Contacts

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "ec2-vpc-ssm-contacts-endpoint-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_vpc" "ssm_contacts_endpoint_required" {
  enforcement_level = input.ec2-vpc-ssm-contacts-endpoint-enforcement-level
  // Skip evaluation when the VPC id is unknown (e.g. plan-time computed value).
  filter = core::try(attrs.id, "") != ""

  connected "aws_vpc_endpoint" {
    min_instances = 1

    connection {
      subject   = "id"
      connected = "vpc_id"
    }

    # Region-agnostic match: com.amazonaws.<region>.<service>(-fips)?
    filter = (
      core::try(connected.aws_vpc_endpoint.vpc_endpoint_type, "") == "Interface" &&
      core::length(core::regexall("^com\\.amazonaws(-us-gov|\\.cn)?\\.[a-zA-Z0-9-]+\\.ssm-contacts(-fips)?$", core::try(connected.aws_vpc_endpoint.service_name, ""))) > 0
    )
  }
}
