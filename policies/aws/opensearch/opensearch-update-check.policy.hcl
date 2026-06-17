# Copyright IBM Corp. 2026

# Opensearch.10 - OpenSearch domains should have the latest software update installed.

policy {}

input "opensearch-update-check-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_opensearch_domain" "latest_software_update_installed" {
    enforcement_level = input.opensearch-update-check-enforcement-level
    locals {
        has_software_updates = core::try(attrs.software_update_options, null) != null
        auto_software_update_enabled = local.has_software_updates ? core::try(attrs.software_update_options[0].auto_software_update_enabled, false) : false
    }

    enforce {
        condition = local.auto_software_update_enabled == true
        error_message = "OpenSearch domain must explicitly enable software_update_options.auto_software_update_enabled = true so service software updates are automatically installed. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/opensearch-controls.html#opensearch-10 for more details."
    }
}
