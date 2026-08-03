# Copyright IBM Corp. 2026

# RDS.41 - RDS for SQL Server DB instances should be encrypted in transit.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "rds-sqlserver-encrypted-in-transit-enforcement-level" {
  type = string
  default = "advisory"
}

# Check SQL Server DB instances for encryption in transit
resource_policy "aws_db_instance" "sqlserver_ssl_check" {
  enforcement_level = input.rds-sqlserver-encrypted-in-transit-enforcement-level
  filter = core::contains(["sqlserver-dev-ee", "sqlserver-ee", "sqlserver-se", "sqlserver-ex", "sqlserver-web"], core::try(attrs.engine, ""))

  connected "aws_db_parameter_group" {
    min_instances = 1

    connection {
      subject   = "parameter_group_name"
      connected = "name"
    }

    enforce {
      condition = core::try([
        for param in core::try(connected.aws_db_parameter_group.parameter, []) : param
        if param.name == "rds.force_ssl"
      ][0].value, null) != null && core::try([
        for param in core::try(connected.aws_db_parameter_group.parameter, []) : param
        if param.name == "rds.force_ssl"
      ][0].value, null) != "0"
      error_message = "RDS SQL Server instance uses parameter group which either does not have the rds.force_ssl parameter explicitly configured or has rds.force_ssl set to '0' (disabled). Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-41 for more details."
    }
  }
}
