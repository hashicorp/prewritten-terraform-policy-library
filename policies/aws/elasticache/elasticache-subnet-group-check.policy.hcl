# ElastiCache.7 - ElastiCache clusters should not use the default subnet group.

policy {}

resource_policy "aws_elasticache_subnet_group" "default-sg" {
    enforce {
        condition = core::try(attrs.name, "default") != "default"
        error_message = "ElastiCache cluster uses the default subnet group. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elasticache-controls.html#elasticache-7 for more details."
    }
}

resource_policy "aws_elasticache_cluster" "default-subnet-group" {
    enforce {
        condition = core::try(attrs.subnet_group_name, "default") != "default"
        error_message = "ElastiCache cluster uses the default subnet group. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elasticache-controls.html#elasticache-7 for more details."
    }
}
