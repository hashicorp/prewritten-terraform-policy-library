# Copyright IBM Corp. 2026

# EventBridge.3 - EventBridge custom event buses should have a resource-based policy attached

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "custom-eventbus-policy-attached-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_cloudwatch_event_bus" "custom_bus_policy_required" {
  enforcement_level = input.custom-eventbus-policy-attached-enforcement-level
  # Only evaluate custom event buses (exclude default bus)
  filter = attrs.name != "default"

  connected "aws_cloudwatch_event_bus_policy" {
    min_instances = 1

    connection {
      subject   = "name"
      connected = "event_bus_name"
    }

    filter = core::try(connected.aws_cloudwatch_event_bus_policy.policy, "") != ""
  }
}
