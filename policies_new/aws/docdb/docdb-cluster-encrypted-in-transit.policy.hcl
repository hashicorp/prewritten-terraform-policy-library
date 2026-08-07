# Copyright IBM Corp. 2026

# Amazon DocumentDB clusters should be encrypted in transit

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "docdb-cluster-encrypted-in-transit-enforcement-level" {
  type    = string
  default = "advisory"
}

input "excludeTlsParameters" {
  type    = string
  default = "disabled,enabled"
}

resource_policy "aws_docdb_cluster" "tls_encryption_required" {
  enforcement_level = input.docdb-cluster-encrypted-in-transit-enforcement-level
  filter = core::try(attrs.db_cluster_parameter_group_name, "") != ""

  locals {
    expected_excluded_tls_parameters = "disabled,enabled"
    cluster_identifier               = core::try(attrs.cluster_identifier, core::try(attrs.id, "unknown"))
    input_matches_supported_value    = input.excludeTlsParameters == local.expected_excluded_tls_parameters
  }

  enforce {
    condition     = local.input_matches_supported_value
    error_message = "input.excludeTlsParameters must remain 'disabled,enabled' because this AWS control is not customizable. Current value: '${input.excludeTlsParameters}'."
  }

  connected "aws_docdb_cluster_parameter_group" {
    connection {
      subject = "db_cluster_parameter_group_name"
      target  = "name"
    }

    cardinality = {
      min_matches = 1
    }

    enforce {
      condition     = core::length([for param in core::try(self.parameter, []) : param if param.name == "tls"]) > 0
      error_message = "DocumentDB cluster '${local.cluster_identifier}' uses parameter group which does not have the 'tls' parameter explicitly set."
    }

    enforce {
      condition = core::length([
        for param in core::try(self.parameter, []) :
        param if param.name == "tls" && !core::contains(core::split(",", input.excludeTlsParameters), param.value)
      ]) > 0
      error_message = "DocumentDB cluster '${local.cluster_identifier}' has TLS set to an excluded value in the parameter group. The excluded TLS parameter values for this control are '${input.excludeTlsParameters}'"
    }
  }
}
