# Copyright IBM Corp. 2026

# RDS for MariaDB DB instances should be encrypted in transit

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "rds-mariadb-instance-encrypted-in-transit-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_db_instance" "mariadb_encrypted_transit" {
  enforcement_level = input.rds-mariadb-instance-encrypted-in-transit-enforcement-level
  filter = attrs.engine == "mariadb"

  locals {
    engine_version = core::try(attrs.engine_version, "0.0.0")
    is_valid_version = core::semverconstraint(local.engine_version, ">=10.5.0")
  }

  connected "aws_db_parameter_group" {
    connection {
      subject = "parameter_group_name"
      target  = "name"
    }

    cardinality = {
      min_matches = 1
    }

    enforce {
      condition = !local.is_valid_version || core::length([
        for p in core::try(self.parameter, []) :
        p if p.name == "require_secure_transport" && p.value == "1"
      ]) > 0
      error_message = "RDS MariaDB instance must have require_secure_transport enabled in parameter group"
    }
  }
}
