# Copyright IBM Corp. 2026

# SQS queue access policies should not allow public access

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "sqs-queue-no-public-access-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  # Fetch all aws_sqs_queue_policy resources in the plan.
  # queue_url is a computed value at plan time, so we cannot filter by it directly.
  # Instead we fetch all and match by queue name below.
  all_sqs_queue_policies = core::getresources("aws_sqs_queue_policy", {})
}

resource_policy "aws_sqs_queue" "no_public_access" {
  enforcement_level = input.sqs-queue-no-public-access-enforcement-level

  locals {
    queue_name = core::try(attrs.name, "")

    # Match aws_sqs_queue_policy resources whose queue_url ends with this queue's name.
    # queue_url format: https://sqs.<region>.amazonaws.com/<account-id>/<queue-name>
    matching_policies = [
      for p in local.all_sqs_queue_policies :
      p if core::endswith(core::try(p.queue_url, ""), local.queue_name)
    ]

    # Use the standalone aws_sqs_queue_policy if present, otherwise fall back to
    # the inline policy attribute on the queue resource itself.
    has_standalone_policy = core::length(local.matching_policies) > 0
    policy_json = local.has_standalone_policy ? core::try(local.matching_policies[0].policy, "") : core::try(attrs.policy, "")
    has_policy  = local.policy_json != ""

    # Parse the policy document.
    policy_doc     = core::try(core::jsondecode(local.policy_json), {})
    raw_statements = core::try(local.policy_doc.Statement, [])

    # Collect public statements (wildcard Principal, no Condition) — list form.
    public_statements_from_list = core::try([
      for stmt in local.raw_statements : stmt
      if (
        core::try(stmt.Effect, "") == "Allow" &&
        (
          core::try(stmt.Principal, "") == "*" ||
          core::contains(core::try([for p in stmt.Principal : p], []), "*") ||
          core::try(stmt.Principal.AWS, "") == "*" ||
          core::contains(core::try([for v in stmt.Principal.AWS : v], []), "*") ||
          core::try(stmt.Principal.Service, "") == "*" ||
          core::contains(core::try([for v in stmt.Principal.Service : v], []), "*") ||
          core::try(stmt.Principal.Federated, "") == "*" ||
          core::contains(core::try([for v in stmt.Principal.Federated : v], []), "*") ||
          core::try(stmt.Principal.CanonicalUser, "") == "*" ||
          core::contains(core::try([for v in stmt.Principal.CanonicalUser : v], []), "*") ||
          core::try(stmt.NotPrincipal, null) != null
        ) &&
        core::try(stmt.Condition, null) == null
      )
    ], [])

    # Single-object Statement form.
    single_stmt_is_public = core::try(local.raw_statements.Effect, "") == "Allow" && (
      core::try(local.raw_statements.Principal, "") == "*" ||
      core::try(local.raw_statements.Principal.AWS, "") == "*" ||
      core::try(local.raw_statements.Principal.Service, "") == "*" ||
      core::try(local.raw_statements.Principal.Federated, "") == "*" ||
      core::try(local.raw_statements.Principal.CanonicalUser, "") == "*" ||
      core::try(local.raw_statements.NotPrincipal, null) != null
    ) && core::try(local.raw_statements.Condition, null) == null

    public_statement_count = core::length(local.public_statements_from_list) + (local.single_stmt_is_public ? 1 : 0)

    is_compliant = !local.has_policy || local.public_statement_count == 0
  }

  enforce {
    condition     = local.is_compliant
    error_message = "SQS queue '${local.queue_name}' has a policy that allows public access. The policy contains ${local.public_statement_count} statement(s) with a wildcard (*) Principal (or NotPrincipal with Allow) and no Condition. Remove wildcard principals or add restrictive conditions."
  }
}
