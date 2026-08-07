# Copyright IBM Corp. 2026

# Connections to Amazon Redshift clusters should be encrypted in transit

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "redshift-require-tls-ssl-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_redshift_cluster" "encryption_in_transit_required" {
  enforcement_level = input.redshift-require-tls-ssl-enforcement-level

  locals {
    param_group_name       = core::try(attrs.cluster_parameter_group_name, "default.redshift-1.0")
    is_default_param_group = local.param_group_name == "default.redshift-1.0"
  }

  enforce {
    condition     = !local.is_default_param_group
    error_message = "Redshift cluster must use a custom parameter group (not the default) with require_ssl = true. Current parameter group: '${local.param_group_name}'"
  }

  connected "aws_redshift_parameter_group" {
    connection {
      subject = "cluster_parameter_group_name"
      target  = "name"
    }

    cardinality = {
      min_matches = 1
    }

    enforce {
      condition = core::length([
        for param in core::try(self.parameter, []) :
        param if param.name == "require_ssl" && param.value == "true"
      ]) > 0
      error_message = "Redshift cluster must use a custom parameter group with require_ssl parameter set to 'true' to encrypt connections in transit. Current parameter group: '${local.param_group_name}'"
    }
  }
}
