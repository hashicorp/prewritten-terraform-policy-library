# Copyright IBM Corp. 2026

# Policy : NetworkFirewall.5 - The default stateless action for Network Firewall policies should be drop or forward for fragmented packets

policy {}

resource_policy "aws_networkfirewall_firewall_policy" "fragment_default_action" {
    filter = attrs.firewall_policy != null && core::length(attrs.firewall_policy) > 0

    locals {
        firewall_policy_config = attrs.firewall_policy[0]
        
        fragment_actions = core::try(local.firewall_policy_config.stateless_fragment_default_actions, [])
        
        has_pass_action = core::contains(local.fragment_actions, "aws:pass")
        
        has_drop = core::contains(local.fragment_actions, "aws:drop")
        has_forward = core::contains(local.fragment_actions, "aws:forward_to_sfe")
        has_valid_action = local.has_drop || local.has_forward
        
        actions_string = core::join(", ", local.fragment_actions)
    }

    enforce {
        condition = core::length(local.fragment_actions) > 0
        error_message = "Network Firewall policy does not have 'stateless_fragment_default_actions' defined. This is a required attribute. Set it to ['aws:drop'] or ['aws:forward_to_sfe']. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/networkfirewall-controls.html#networkfirewall-5 for more details."
    }

    enforce {
        condition = !local.has_pass_action
        error_message = "Network Firewall policy has 'aws:pass' in stateless_fragment_default_actions [${local.actions_string}]. This allows unintended fragmented traffic. Change to ['aws:drop'] or ['aws:forward_to_sfe']. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/networkfirewall-controls.html#networkfirewall-5 for more details."
    }

    enforce {
        condition = local.has_valid_action
        error_message = "Network Firewall policy must use 'aws:drop' or 'aws:forward_to_sfe' for stateless_fragment_default_actions. Current actions: [${local.actions_string}]. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/networkfirewall-controls.html#networkfirewall-5 for more details."
    }
}
