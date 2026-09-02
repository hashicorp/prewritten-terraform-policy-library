# Copyright IBM Corp. 2026

policytest {
  targets = [
    "redshift-require-tls-ssl.policy.hcl"
  ]
}
# Pass case: Cluster with custom parameter group that has require_ssl = true
resource "aws_redshift_cluster" "pass_custom_param_group_with_ssl" {
  attrs = {
    cluster_identifier = "compliant-cluster"
    cluster_parameter_group_name = "custom-param-group"
    node_type = "dc2.large"
    master_username = "admin"
  }
}

resource "aws_redshift_parameter_group" "custom_with_ssl" {
  attrs = {
    name = "custom-param-group"
    family = "redshift-1.0"
    parameter = [
      {
        name = "require_ssl"
        value = "true"
      }
    ]
  }
}

# Pass case: Cluster using the default.redshift-2.0 parameter group (require_ssl is true by default)
resource "aws_redshift_cluster" "pass_default_redshift_2_param_group" {
  attrs = {
    cluster_identifier = "default-2-cluster"
    cluster_parameter_group_name = "default.redshift-2.0"
    node_type = "dc2.large"
    master_username = "admin"
  }
}

# Pass case: Cluster with no cluster_parameter_group_name set (falls back to default.redshift-2.0)
resource "aws_redshift_cluster" "pass_no_param_group_name" {
  attrs = {
    cluster_identifier = "no-param-group-cluster"
    node_type = "dc2.large"
    master_username = "admin"
  }
}

# Fail case: Cluster using default.redshift-1.0 parameter group (not whitelisted, no custom param group found)
resource "aws_redshift_cluster" "fail_default_redshift_1_param_group" {
  expect_failure = true
  attrs = {
    cluster_identifier = "default-1-cluster"
    cluster_parameter_group_name = "default.redshift-1.0"
    node_type = "dc2.large"
    master_username = "admin"
  }
}

# Fail case: Cluster with custom parameter group but no require_ssl parameter
resource "aws_redshift_cluster" "fail_missing_require_ssl" {
  expect_failure = true
  attrs = {
    cluster_identifier = "no-ssl-cluster"
    cluster_parameter_group_name = "custom-no-ssl"
    node_type = "dc2.large"
    master_username = "admin"
  }
}

resource "aws_redshift_parameter_group" "no_ssl_param" {
  attrs = {
    name = "custom-no-ssl"
    family = "redshift-1.0"
    parameter = [
      {
        name = "max_connections"
        value = "100"
      }
    ]
  }
}

# Fail case: Cluster with custom parameter group but require_ssl = false
resource "aws_redshift_cluster" "fail_require_ssl_false" {
  expect_failure = true
  attrs = {
    cluster_identifier = "ssl-disabled-cluster"
    cluster_parameter_group_name = "custom-ssl-false"
    node_type = "dc2.large"
    master_username = "admin"
  }
}

resource "aws_redshift_parameter_group" "ssl_false_param" {
  attrs = {
    name = "custom-ssl-false"
    family = "redshift-1.0"
    parameter = [
      {
        name = "require_ssl"
        value = "false"
      }
    ]
  }
}