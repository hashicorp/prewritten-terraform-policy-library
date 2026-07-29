# Copyright IBM Corp. 2026

# Policy : NetworkFirewall.9 - Network Firewall firewalls should have deletion protection enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 7.0.0"
    }
  }
}

input "network-firewall-deletion-protection-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_networkfirewall_firewall" "deletion_protection_enabled" {
    enforcement_level = input.network-firewall-deletion-protection-enabled-enforcement-level
    locals {
        delete_protection = core::try(attrs.delete_protection, false)
    }

    enforce {
        condition = local.delete_protection == true
        error_message = "Network Firewall does not have deletion protection enabled. Set 'delete_protection = true' to protect against accidental deletion. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/networkfirewall-controls.html#networkfirewall-9 for more details."
    }
}
