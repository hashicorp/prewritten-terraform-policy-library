# Copyright IBM Corp. 2026

# RDS.44 - RDS for MariaDB DB instances should be encrypted in transit.

policy {}

input "rds-mariadb-instance-encrypted-in-transit-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_db_instance" "mariadb_encrypted_transit" {
  enforcement_level = input.rds-mariadb-instance-encrypted-in-transit-enforcement-level
  filter = (
    attrs.engine == "mariadb" &&
    core::semverconstraint(core::try(attrs.engine_version, "0.0.0"), ">=10.5.0")
  )

  connected "aws_db_parameter_group" {
    min_instances = 1

    connection {
      subject   = "parameter_group_name"
      connected = "name"
    }

    enforce {
      condition = core::length([
        for param in core::try(connected.aws_db_parameter_group.parameter, []) : param
        if param.name == "require_secure_transport"
      ]) > 0 && core::try([
        for param in core::try(connected.aws_db_parameter_group.parameter, []) : param
        if param.name == "require_secure_transport"
      ][0].value, "") == "1"
      error_message = "RDS MariaDB instance must have require_secure_transport enabled in parameter group. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-44 for more details."
    }
  }
}
