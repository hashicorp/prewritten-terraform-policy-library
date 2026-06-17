# Copyright IBM Corp. 2026

# ELB.22 - ELB target groups should use encrypted transport protocols

policy {}

input "elbv2-targetgroup-protocol-encrypted-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_lb_target_group" "encrypted_protocol_required" {
    enforcement_level = input.elbv2-targetgroup-protocol-encrypted-enforcement-level
    locals {
        target_type = core::try(attrs.target_type, "instance")
        protocol = core::try(attrs.protocol, "")
        encrypted_protocols = ["HTTPS", "TLS", "QUIC"]
        excluded_target_types = ["lambda", "alb"]
        is_excluded = core::contains(local.excluded_target_types, local.target_type) || local.protocol == "GENEVE"
        uses_encrypted_protocol = core::contains(local.encrypted_protocols, local.protocol)
    }

    enforce {
        condition = local.is_excluded || local.uses_encrypted_protocol
        error_message = "ELB target group must use an encrypted transport protocol. Allowed protocols are HTTPS, TLS or QUIC. Target groups with target_type 'lambda' or 'alb', and target groups using protocol 'GENEVE', are excluded. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-22 for more details."
    }
}
