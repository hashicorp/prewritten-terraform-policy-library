# Copyright IBM Corp. 2026

# RDS.46 - RDS DB instances should not be deployed in public subnets with routes to internet gateways.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "rds-instance-subnet-igw-check-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_db_instance" "no_public_subnet_igw" {
  enforcement_level = input.rds-instance-subnet-igw-check-enforcement-level

  connected "aws_db_subnet_group" {
    min_instances = 1

    connection {
      subject   = "db_subnet_group_name"
      connected = "name"
    }

    connected "aws_subnet" {
      min_instances = 1

      connection {
        subject_list = "subnet_ids"
        connected    = "id"
      }

      connected "aws_route_table_association" {
        connection {
          subject   = "id"
          connected = "subnet_id"
        }

        connected "aws_route_table" {
          connection {
            subject   = "route_table_id"
            connected = "id"
          }

          enforce {
            condition = core::length([
              for route in core::try(connected.aws_route_table.route, []) : route
              if (
                (core::try(route.cidr_block, "") == "0.0.0.0/0" || core::try(route.ipv6_cidr_block, "") == "::/0") &&
                core::length(core::regexall("^igw-", core::try(route.gateway_id, ""))) > 0
              )
            ]) == 0
            error_message = "RDS DB instance subnets must not have default routes to an Internet Gateway. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-46 for more details."
          }

          # A managed association may point to an externally managed route table.
          fallback {
            enforce {
              condition = core::try(
                core::length([
                  for route in core::getdatasource("aws_route_table", {
                    route_table_id = connected.aws_route_table_association.route_table_id
                  }).routes : route
                  if (
                    (core::try(route.cidr_block, "") == "0.0.0.0/0" || core::try(route.ipv6_cidr_block, "") == "::/0") &&
                    core::length(core::regexall("^igw-", core::try(route.gateway_id, ""))) > 0
                  )
                ]) == 0,
                false
              )
              error_message = "RDS DB instance subnets must use resolvable route tables without default routes to an Internet Gateway. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-46 for more details."
            }
          }
        }

        # If Terraform has no explicit association tuple, resolve the effective
        # route table from AWS. The first query also detects external explicit
        # associations; the second resolves an implicit main association.
        fallback {
          enforce {
            condition = core::try(
              core::length([
                for route in core::getdatasource("aws_route_table", {
                  subnet_id = connected.aws_subnet.id
                }).routes : route
                if (
                  (core::try(route.cidr_block, "") == "0.0.0.0/0" || core::try(route.ipv6_cidr_block, "") == "::/0") &&
                  core::length(core::regexall("^igw-", core::try(route.gateway_id, ""))) > 0
                )
              ]) == 0,
              core::length([
                for route in core::getdatasource("aws_route_table", {
                  vpc_id = connected.aws_subnet.vpc_id
                  filter = core::toset([{
                    name   = "association.main"
                    values = core::toset(["true"])
                  }])
                }).routes : route
                if (
                  (core::try(route.cidr_block, "") == "0.0.0.0/0" || core::try(route.ipv6_cidr_block, "") == "::/0") &&
                  core::length(core::regexall("^igw-", core::try(route.gateway_id, ""))) > 0
                )
              ]) == 0,
              false
            )
            error_message = "RDS DB instance subnets must use resolvable route tables without default routes to an Internet Gateway. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-46 for more details."
          }
        }
      }
    }
  }
}
