# Copyright IBM Corp. 2026

# RDS DB instances should have deletion protection enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "rds-instance-deletion-protection-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_db_instance" "deletion_protection_enabled" {
    enforcement_level = input.rds-instance-deletion-protection-enabled-enforcement-level
    filter = local.is_supported_engine
    locals {
        engine = core::try(attrs.engine, "")
        supported_engines = ["mariadb", "mysql", "custom-oracle-ee", "oracle-ee-cdb", "oracle-se2-cdb", "oracle-ee", "oracle-se2", "oracle-se1", "oracle-se", "postgres", "sqlserver-ee", "sqlserver-se", "sqlserver-ex", "sqlserver-web"]
        is_supported_engine = core::contains(local.supported_engines, local.engine)
    }
    enforce {
        condition = core::try(attrs.deletion_protection, false) == true
        error_message = "RDS DB instances should have deletion protection enabled"
    }
}
