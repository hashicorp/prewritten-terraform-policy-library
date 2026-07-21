# Copyright IBM Corp. 2026

# Policy: Redshift.2 - Connections to Amazon Redshift clusters should be encrypted in transit

policy {}

input "redshift-require-tls-ssl-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_redshift_cluster" "encryption_in_transit_required" {
  enforcement_level = input.redshift-require-tls-ssl-enforcement-level
  locals {
    # Get the parameter group name (custom or default)
    param_group_name = core::try(attrs.cluster_parameter_group_name, "default.redshift-1.0")
    
    # Check if using default parameter group
    is_default_param_group = local.param_group_name == "default.redshift-1.0"
  }

  connected "aws_redshift_parameter_group" {
    min_instances = 1

    connection {
      subject   = "cluster_parameter_group_name"
      connected = "name"
    }

    # A cluster needs at least one matching custom group with require_ssl enabled.
    filter = !local.is_default_param_group && core::length([
        for param in core::try(connected.aws_redshift_parameter_group.parameter, []) :
        param if param.name == "require_ssl" && param.value == "true"
      ]) > 0
  }
}
