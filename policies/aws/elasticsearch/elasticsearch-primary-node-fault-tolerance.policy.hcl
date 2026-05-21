# ES.7 - Elasticsearch domains should be configured with at least three dedicated master nodes

policy {}

resource_policy "aws_elasticsearch_domain" "dedicated_master_nodes" {
    locals {
        cluster_config = core::try(attrs.cluster_config, [])
        
        # Check if dedicated master is enabled (default to false if not set)
        dedicated_master_enabled = core::try(local.cluster_config[0].dedicated_master_enabled, false)
        
        # Get dedicated master count (default to 0 if not set)
        dedicated_master_count = core::try(local.cluster_config[0].dedicated_master_count, 0)
    }

    enforce {
        condition = local.dedicated_master_enabled == true && local.dedicated_master_count >= 3
        error_message = "Elasticsearch domain does not meet ES.7 requirements. Dedicated master nodes must be enabled with at least 3 nodes. Current configuration: dedicated_master_enabled=${local.dedicated_master_enabled}, dedicated_master_count=${local.dedicated_master_count}. Set cluster_config.dedicated_master_enabled=true and cluster_config.dedicated_master_count>=3. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/es-controls.html#es-7 for more details."
    }
}
