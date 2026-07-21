# Copyright IBM Corp. 2026

# Policy: DocumentDB.6 - Amazon DocumentDB clusters should be encrypted in transit

policy {}

input "docdb-cluster-encrypted-in-transit-enforcement-level" {
  type = string
  default = "advisory"
}

input "excludeTlsParameters" {
  type = string
  default = "disabled,enabled"
}

resource_policy "aws_docdb_cluster" "tls_input_supported" {
  enforcement_level = input.docdb-cluster-encrypted-in-transit-enforcement-level
  filter = core::try(attrs.db_cluster_parameter_group_name, "") != ""

  locals {
    expected_excluded_tls_parameters = "disabled,enabled"
    input_matches_supported_value = input.excludeTlsParameters == local.expected_excluded_tls_parameters
  }

  enforce {
    condition = local.input_matches_supported_value
    error_message = "input.excludeTlsParameters must remain 'disabled,enabled' because this AWS control is not customizable. Current value: '${input.excludeTlsParameters}'."
  }
}

resource_policy "aws_docdb_cluster" "tls_encryption_required" {
  enforcement_level = input.docdb-cluster-encrypted-in-transit-enforcement-level
  filter = core::try(attrs.db_cluster_parameter_group_name, "") != ""

  locals {
    param_group_name = core::try(attrs.db_cluster_parameter_group_name, "")
    cluster_identifier = core::try(attrs.cluster_identifier, core::try(attrs.id, "unknown"))
    excluded_tls_values = core::split(",", input.excludeTlsParameters)
  }

  connected "aws_docdb_cluster_parameter_group" {
    min_instances = 1

    connection {
      subject   = "db_cluster_parameter_group_name"
      connected = "name"
    }

    enforce {
      condition = core::try([
        for param in core::try(connected.aws_docdb_cluster_parameter_group.parameter, []) :
        param if param.name == "tls"
      ][0].value, "") != ""
      error_message = "DocumentDB cluster '${local.cluster_identifier}' uses parameter group '${local.param_group_name}' which does not have the 'tls' parameter explicitly set. Set the TLS parameter to a value other than the excluded values '${input.excludeTlsParameters}'. Refer to https://docs.aws.amazon.com/config/latest/developerguide/docdb-cluster-encrypted-in-transit.html for more details."
    }

    enforce {
      condition = !core::contains(local.excluded_tls_values, core::try([
        for param in core::try(connected.aws_docdb_cluster_parameter_group.parameter, []) :
        param if param.name == "tls"
      ][0].value, ""))
      error_message = "DocumentDB cluster '${local.cluster_identifier}' has TLS set to excluded value '${core::try([for param in core::try(connected.aws_docdb_cluster_parameter_group.parameter, []) : param if param.name == "tls"][0].value, "")}' in parameter group '${local.param_group_name}'. The excluded TLS parameter values for this control are '${input.excludeTlsParameters}'. Refer to https://docs.aws.amazon.com/config/latest/developerguide/docdb-cluster-encrypted-in-transit.html for more details."
    }
  }
}
