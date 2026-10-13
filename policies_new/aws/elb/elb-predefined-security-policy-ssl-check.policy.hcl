# Copyright IBM Corp. 2026

# Classic Load Balancers with SSL listeners should use a predefined security policy that has strong AWS Configuration

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "elb-predefined-security-policy-ssl-check-enforcement-level" {
  type    = string
  default = "advisory"
}

# GAP 4b (partial conversion): Both connected blocks below resolve correctly
# from aws_elb via load_balancer_name. However the full fidelity check requires
# correlating results across the two blocks: every SSL listener's policy_names
# must contain a name that was validated as compliant in the first block. There
# is no shared state between connected blocks so that cross-block check cannot
# be expressed. The conversion below asserts the two conditions independently:
#   1. At least one aws_load_balancer_policy on this ELB sets the required
#      Reference-Security-Policy attribute.
#   2. Every aws_load_balancer_listener_policy on this ELB has at least one
#      policy name attached.
# This will not catch the case where a listener is wired to a non-compliant
# policy even though a compliant policy exists on the same ELB.

resource_policy "aws_elb" "ssl_predefined_security_policy" {
  enforcement_level = input.elb-predefined-security-policy-ssl-check-enforcement-level
  locals {
    ssl_listeners = [for l in core::try(attrs.listener, []) : l if core::contains(["HTTPS", "SSL"], l.lb_protocol)]
  }

  filter = core::length(local.ssl_listeners) > 0

  # Block 1: every aws_load_balancer_policy on this ELB must set the required
  # Reference-Security-Policy attribute.
  connected "aws_load_balancer_policy" {
    connection {
      reverse = true
      subject = "load_balancer_name"
      target  = "name"
    }

    cardinality = {
      min_matches   = 1
      error_message = "ELB '${attrs.name}' has no aws_load_balancer_policy defined. At least one policy with Reference-Security-Policy = ELBSecurityPolicy-TLS-1-2-2017-01 is required"
    }

    enforce {
      condition = core::length([
        for attr in core::try(self.policy_attribute, []) :
        attr if attr.name == "Reference-Security-Policy" &&
                attr.value == "ELBSecurityPolicy-TLS-1-2-2017-01"
      ]) > 0
      error_message = "Policy '${self.policy_name}' on ELB '${attrs.name}' does not set Reference-Security-Policy to ELBSecurityPolicy-TLS-1-2-2017-01"
    }
  }

  # Block 2: every aws_load_balancer_listener_policy on this ELB must have at
  # least one policy name attached. Cannot verify the name matches a compliant
  # policy from block 1 — see GAP 4b comment above.
  connected "aws_load_balancer_listener_policy" {
    connection {
      reverse = true
      subject = "load_balancer_name"
      target  = "name"
    }

    cardinality = {
      min_matches   = 1
      error_message = "ELB '${attrs.name}' has no aws_load_balancer_listener_policy defined"
    }

    enforce {
      condition     = core::length(core::try(self.policy_names, [])) > 0
      error_message = "Listener policy on port ${self.load_balancer_port} of ELB '${attrs.name}' has no policies attached"
    }
  }
}
