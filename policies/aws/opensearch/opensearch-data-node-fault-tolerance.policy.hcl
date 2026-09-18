# Copyright IBM Corp. 2026

# OpenSearch domains should have at least three data nodes

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "opensearch-data-node-fault-tolerance-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_opensearch_domain" "data_node_fault_tolerance" {
    enforcement_level = input.opensearch-data-node-fault-tolerance-enforcement-level

    locals {
        cluster_config = core::try(attrs.cluster_config, [])
        instance_count_raw = core::length(local.cluster_config) > 0 ? core::try(local.cluster_config[0].instance_count, null) : null
        instance_count     = local.instance_count_raw != null ? local.instance_count_raw : 1
        zone_awareness_enabled_raw = core::try(local.cluster_config[0].zone_awareness_enabled, null)
        zone_awareness_enabled     = local.zone_awareness_enabled_raw != null ? local.zone_awareness_enabled_raw : false
    }

    enforce {
        condition = local.instance_count >= 3
        error_message = "OpenSearch domain must have at least 3 data nodes for high availability. Set cluster_config.instance_count to 3 or more"
    }

    enforce {
        condition = local.zone_awareness_enabled == true
        error_message = "OpenSearch domain must have zone awareness enabled for fault tolerance. Set cluster_config.zone_awareness_enabled = true"
    }
}
