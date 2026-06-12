# ElastiCache.5 - ElastiCache replication groups should be encrypted in transit.

policy {}

input "elasticache-repl-grp-encrypted-in-transit-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_elasticache_replication_group" "encryption-in-transit" {
    enforcement_level = input.elasticache-repl-grp-encrypted-in-transit-enforcement-level
    enforce {
        condition = core::try(attrs.transit_encryption_enabled, false)
        error_message = "ElastiCache replication group does not have encryption in transit enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elasticache-controls.html#elasticache-5 for more details."
    }
}