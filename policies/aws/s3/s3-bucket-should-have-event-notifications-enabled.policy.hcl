# Copyright IBM Corp. 2026

# S3 buckets should have event notifications enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "s3-bucket-should-have-event-notifications-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

input "eventTypes" {
  type    = string
  default = ""
}

resource_policy "aws_s3_bucket" "event_notifications_enabled" {
  locals {
    notifications = core::getresources("aws_s3_bucket_notification", {
      bucket = attrs.id
    })
    # A notification only counts when it defines at least one topic block (null-safe).
    notifications_with_topic = [
      for n in local.notifications : n
      if core::length(core::try(n.topic, null) != null ? n.topic : []) > 0
    ]

    event_types_input = core::trimspace(input.eventTypes)
    has_event_filter  = local.event_types_input != ""
    required_events   = local.has_event_filter ? [for e in core::split(",", local.event_types_input) : core::trimspace(e)] : []

    all_configured_events = core::flatten([
      for n in local.notifications_with_topic : [
        for topic in (core::try(n.topic, null) != null ? n.topic : []) :
          core::try(topic.events, [])
      ]
    ])

    # When an event filter is provided, every required event type must appear in the
    # configured events. When no filter is provided, any topic notification is sufficient.
    all_required_events_present = local.has_event_filter ? core::length([
      for e in local.required_events : e
      if !core::contains(local.all_configured_events, e)
    ]) == 0 : true
  }

  enforcement_level = input.s3-bucket-should-have-event-notifications-enabled-enforcement-level
  enforce {
    condition     = core::length(local.notifications_with_topic) > 0 && local.all_required_events_present
    error_message = "S3 Buckets should have event notifications enabled${local.has_event_filter ? " for the following event types: ${input.eventTypes}" : ""}"
  }
}
