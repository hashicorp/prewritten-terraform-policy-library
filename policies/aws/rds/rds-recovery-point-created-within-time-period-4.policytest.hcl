# Copyright IBM Corp. 2026

# Separate file: assumes inputs.resource_tags = { Team = "payments" } (see Test
# File Rules case 1 - scenarios need different inputs {} values). This exercises
# the resource_tags scope filter in isolation from the main test file's default
# inputs.

policytest {
  targets = ["rds-recovery-point-created-within-time-period.policy.hcl"]
}

inputs {
  rds-recovery-point-created-within-time-period-resource_tags = {
    Team = "payments"
  }
}

# Scenario 14: PASS - this resource's tags do not match input.resource_tags,
# so it is out of scope and filtered out entirely. It would otherwise fail
# (backup_retention_period = 0, no backup selection), but the scope filter means
# it is never evaluated and therefore passes.
resource "aws_db_instance" "out_of_scope_by_tags_db" {
  attrs = {
    identifier              = "other-tagged-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:other-tagged-db"
    backup_retention_period = 0
    backup_window           = "09:46-10:16"
    tags = {
      Team = "logistics"
    }
  }
}
