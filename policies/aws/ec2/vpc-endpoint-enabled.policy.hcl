# Policy : EC2.55 - VPCs should be configured with an interface endpoint for the services

policy {}

input "serviceNames" {
  type    = string
  default = "ecr.api"
}

// Optional comma-separated list of VPC IDs to evaluate. Empty = evaluate all VPCs.
input "vpcIds" {
  type    = string
  default = ""
}

resource_policy "aws_vpc" "vpc_endpoint_required" {
  // Skip evaluation when the VPC id is unknown (e.g. plan-time computed value).
  // Without this guard, getresources("aws_vpc_endpoint", { vpc_id = null }) returns
  // nothing and every VPC would falsely report "missing endpoint".
  filter = core::try(attrs.id, "") != ""

  locals {
    vpc_id = core::try(attrs.id, "")

    target_vpc_ids      = input.vpcIds != "" ? [for v in core::split(",", input.vpcIds) : core::trimspace(v)] : []
    should_evaluate_vpc = local.vpc_id != "" && (input.vpcIds == "" || core::contains(local.target_vpc_ids, local.vpc_id))

    raw_services = [for s in core::split(",", input.serviceNames) : core::trimspace(s)]

    service_patterns = [
      for s in local.raw_services :
      (core::length(core::regexall("^com\\.amazonaws\\.", s)) > 0
        ? "^${s}(-fips)?$"
        : "^com\\.amazonaws\\.[a-z0-9-]+\\.${s}(-fips)?$")
    ]

    all_endpoints = core::getresources("aws_vpc_endpoint", { vpc_id = local.vpc_id })

    // For each required service, the list of matching endpoints.
    matches_per_service = [
      for pattern in local.service_patterns : [
        for e in local.all_endpoints :
        e if core::length(core::regexall(pattern, core::try(e.service_name, ""))) > 0
      ]
    ]

    // Services that have zero matching endpoints.
    missing_services = [
      for idx, matches in local.matches_per_service :
      local.raw_services[idx] if core::length(matches) == 0
    ]

    all_services_have_endpoint = core::length(local.missing_services) == 0
    missing_services_display   = core::length(local.missing_services) > 0 ? core::join(", ", local.missing_services) : ""
  }

  enforce {
    condition     = !local.should_evaluate_vpc || local.all_services_have_endpoint
    error_message = "VPC '${local.vpc_id}' is missing a VPC endpoint for service(s): ${local.missing_services_display}. Each service in input.serviceNames must have a matching com.amazonaws.<region>.<service> endpoint (Interface or Gateway, FIPS variant also accepted). Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-55 and https://docs.aws.amazon.com/config/latest/developerguide/vpc-endpoint-enabled.html for more details."
  }
}
