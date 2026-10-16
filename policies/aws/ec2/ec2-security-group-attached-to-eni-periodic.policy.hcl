# Copyright IBM Corp. 2026

# Security groups should be attached to an elastic network interface

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "ec2-security-group-attached-to-eni-periodic-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  periodic_sg_refs_from_lists = core::flatten([
    [for r in core::getresources("aws_network_interface", {}) : core::try([for x in r.security_groups : x], [])],
    [for r in core::getresources("aws_instance", {}) : core::try([for x in r.vpc_security_group_ids : x], [])],
    [for r in core::getresources("aws_db_instance", {}) : core::try([for x in r.vpc_security_group_ids : x], [])],
    [for r in core::getresources("aws_rds_cluster", {}) : core::try([for x in r.vpc_security_group_ids : x], [])],
    [for r in core::getresources("aws_lb", {}) : core::try([for x in r.security_groups : x], [])],
    [for r in core::getresources("aws_elasticache_cluster", {}) : core::try([for x in r.security_group_ids : x], [])],
    [for r in core::getresources("aws_elasticache_replication_group", {}) : core::try([for x in r.security_group_ids : x], [])],
    [for r in core::getresources("aws_lambda_function", {}) : core::try([for x in r.vpc_config[0].security_group_ids : x], [])],
    [for r in core::getresources("aws_ecs_service", {}) : core::try([for x in r.network_configuration[0].security_groups : x], [])],
    [for r in core::getresources("aws_eks_cluster", {}) : core::try([for x in r.vpc_config[0].security_group_ids : x], [])],
    [for r in core::getresources("aws_vpc_endpoint", {}) : core::try([for x in r.security_group_ids : x], [])],
    [for r in core::getresources("aws_efs_mount_target", {}) : core::try([for x in r.security_groups : x], [])],
  ])
  periodic_sg_refs_from_attachments = [
    for r in core::getresources("aws_network_interface_sg_attachment", {}) : core::try(r.security_group_id, "")
  ]
  periodic_sg_attached_ids = core::concat(local.periodic_sg_refs_from_lists, local.periodic_sg_refs_from_attachments)
}

resource_policy "aws_security_group" "attached_to_eni" {
  locals {
    sg_id_raw   = core::try(attrs.id, null)
    sg_id       = local.sg_id_raw != null ? local.sg_id_raw : ""
    is_attached = local.sg_id != "" && core::contains(local.periodic_sg_attached_ids, local.sg_id)
  }

  enforcement_level = input.ec2-security-group-attached-to-eni-periodic-enforcement-level

  enforce {
    condition     = local.is_attached
    error_message = "Security group '${local.sg_id}' is not used by any elastic network interface in this Terraform plan (network interfaces, EC2 instances, RDS, load balancers, ElastiCache, Lambda, ECS, EKS, VPC endpoints or EFS mount targets). Non-default security groups must be attached to an elastic network interface."
  }
}
