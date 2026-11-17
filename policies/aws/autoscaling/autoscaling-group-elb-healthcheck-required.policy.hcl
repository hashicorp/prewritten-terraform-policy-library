# Copyright IBM Corp. 2026

# autoscaling-group-elb-healthcheck-required

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "autoscaling-group-elb-healthcheck-required-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  all_attachments = core::getresources("aws_autoscaling_attachment", {})

  load_balancer_attachments = [
    for att in local.all_attachments : att
    if core::try(att.elb, "") != "" || core::try(att.lb_target_group_arn, "") != ""
  ]

  attached_asg_names = [for att in local.load_balancer_attachments : core::try(att.autoscaling_group_name, "")]
}

resource_policy "aws_autoscaling_group" "elb_healthcheck_required" {
  enforcement_level = input.autoscaling-group-elb-healthcheck-required-enforcement-level
  filter = core::length([
    for n in local.attached_asg_names : n
    if n == core::try(attrs.name, "")
  ]) > 0 || core::length(core::try(attrs.load_balancers, [])) > 0 || core::length(core::try(attrs.target_group_arns, [])) > 0

  locals {
    asg_name          = core::try(attrs.name, "")
    health_check_type = core::try(attrs.health_check_type, "")

    is_compliant = local.health_check_type == "ELB"
  }

  enforce {
    condition     = local.is_compliant
    error_message = "Attribute 'health_check_type' must be 'ELB' for 'aws_autoscaling_group' and should be associated with the load balancer resource."
  }
}
