# Copyright IBM Corp. 2026

# Elasticsearch domains should be configured with at least three dedicated master nodes

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "elasticsearch-primary-node-fault-tolerance-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_elasticsearch_domain" "dedicated_master_nodes" {
    enforcement_level = input.elasticsearch-primary-node-fault-tolerance-enforcement-level
    locals {
        cluster_config = core::try(attrs.cluster_config, [])
        
        # Check if dedicated master is enabled (default to false if not set)
        dedicated_master_enabled_raw = core::try(local.cluster_config[0].dedicated_master_enabled, null)
        dedicated_master_enabled = local.dedicated_master_enabled_raw != null ? local.dedicated_master_enabled_raw : false

        # Get dedicated master count (default to 0 if not set)
        dedicated_master_count_raw = core::try(local.cluster_config[0].dedicated_master_count, null)
        dedicated_master_count = local.dedicated_master_count_raw != null ? local.dedicated_master_count_raw : 0
    }

    enforce {
        condition = local.dedicated_master_enabled == true && local.dedicated_master_count >= 3
        error_message = "Elasticsearch domain does not meet ES.7 requirements. Dedicated master nodes must be enabled with at least 3 nodes. Current configuration: dedicated_master_enabled=${local.dedicated_master_enabled}, dedicated_master_count=${local.dedicated_master_count}. Set cluster_config.dedicated_master_enabled=true and cluster_config.dedicated_master_count>=3"
    }
}
