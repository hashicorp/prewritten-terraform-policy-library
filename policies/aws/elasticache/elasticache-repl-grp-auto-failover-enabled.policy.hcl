# ElastiCache.3 - ElastiCache replication groups should have automatic failover enabled.

policy {}

resource_policy "aws_elasticache_replication_group" "auto-failover-enabled" {
    enforce {
        condition = core::try(attrs.auto_failover_enabled, false) == true ? core::try(attrs.num_cache_clusters, 1) >= 2 : false
        error_message = "ElastiCache replication groups should have automatic failover enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elasticache-controls.html#elasticache-3 for more details."
    }
}