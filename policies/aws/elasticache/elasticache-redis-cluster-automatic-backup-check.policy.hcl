# ElastiCache.1 - ElastiCache (Redis OSS) clusters should have automatic backups enabled. 

policy {}

input "snapshot_retention_period" {
    type = number
    default = 15
}

resource_policy "aws_elasticache_cluster" "backup-check"{
    filter = core::try(attrs.engine, "redis") == "redis"

    locals {
        snapshot_retention_limit = core::try(attrs.snapshot_retention_limit, 0)
    }

    enforce {
        condition = local.snapshot_retention_limit != 0 && local.snapshot_retention_limit >= input.snapshot_retention_period
        error_message = "ElastiCache Redis clusters should have automatic backup turned on. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elasticache-controls.html#elasticache-1 for more details."
    }
}

resource_policy "aws_elasticache_replication_group" "redis-backup-check"{
    filter = core::try(attrs.engine, "redis") == "redis"

    locals {
        snapshot_retention_limit = core::try(attrs.snapshot_retention_limit, 0)
    }

    enforce {
        condition = local.snapshot_retention_limit != 0 && local.snapshot_retention_limit >= input.snapshot_retention_period
        error_message = "ElastiCache Redis clusters should have automatic backup turned on. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elasticache-controls.html#elasticache-1 for more details."
    }
}