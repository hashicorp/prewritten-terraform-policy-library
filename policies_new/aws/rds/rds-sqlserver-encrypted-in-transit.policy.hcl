# Copyright IBM Corp. 2026

# RDS for SQL Server DB instances should be encrypted in transit

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "rds-sqlserver-encrypted-in-transit-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_db_instance" "sqlserver_ssl_check" {
  enforcement_level = input.rds-sqlserver-encrypted-in-transit-enforcement-level
  filter = core::contains(["sqlserver-dev-ee", "sqlserver-ee", "sqlserver-se", "sqlserver-ex", "sqlserver-web"], core::try(attrs.engine, ""))

  connected "aws_db_parameter_group" {
    connection {
      subject = "parameter_group_name"
      target  = "name"
    }

    cardinality = {
      min_matches = 1
    }

    enforce {
      condition = core::length([
        for param in core::try(self.parameter, []) :
        param if param.name == "rds.force_ssl" && param.value != "0"
      ]) > 0
      error_message = "RDS SQL Server instance uses parameter group which either does not have rds.force_ssl explicitly configured or has it set to '0' (disabled)"
    }
  }
}
