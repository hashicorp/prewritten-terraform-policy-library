# Copyright IBM Corp. 2026

# EventBridge.3 - EventBridge custom event buses should have a resource-based policy attached

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 7.0.0"
    }
  }
}

input "custom-eventbus-policy-attached-enforcement-level" {
  type = string
  default = "advisory"
}

locals {
    all_event_bus_policies = core::getresources("aws_cloudwatch_event_bus_policy", {})
}

resource_policy "aws_cloudwatch_event_bus" "custom_bus_policy_required" {
    enforcement_level = input.custom-eventbus-policy-attached-enforcement-level
    # Only evaluate custom event buses (exclude default bus)
    filter = attrs.name != "default"

    locals {
        # Get the event bus name
        bus_name = core::try(attrs.name, "")
        
        # Find policies that reference this event bus
        # Note: event_bus_name in policy defaults to "default" if not specified
        matching_policies = [
            for policy in local.all_event_bus_policies :
            policy if core::try(policy.event_bus_name, "default") == local.bus_name
        ]
        
        # Check if at least one policy exists for this bus
        has_policy = core::length(local.matching_policies) > 0
    }

    # Enforce: Custom event bus must have an associated policy
    enforce {
        condition = local.has_policy
        error_message = "Custom EventBridge event bus must have a resource-based policy attached via aws_cloudwatch_event_bus_policy resource. This is required for PCI DSS v4.0.1 compliance to control cross-account access. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/eventbridge-controls.html#eventbridge-3 for more details."
    }

    # Enforce: Policy document must not be empty (short-circuits when no policy
    # is attached so the previous enforce owns that diagnostic).
    enforce {
        condition = !local.has_policy || core::try(local.matching_policies[0].policy, "") != ""
        error_message = "EventBridge event bus has an associated aws_cloudwatch_event_bus_policy, but the policy document is empty or null. A valid IAM policy document must be provided. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/eventbridge-controls.html#eventbridge-3 for more details."
    }
}
