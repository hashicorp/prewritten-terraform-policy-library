# Copyright IBM Corp. 2026

# Separate file: assumes inputs.resource_id = "specific-db" (see Test File Rules
# case 1 - scenarios need different inputs {} values). This exercises the
# resource_id scope filter in isolation from the main test file's default inputs.

policytest {
  targets = ["rds-recovery-point-created-within-time-period.policy.hcl"]
}

inputs {
  rds-recovery-point-created-within-time-period-resource_id = "specific-db"
}

# Scenario 13: PASS - this resource's identifier does not match input.resource_id,
# so it is out of scope and filtered out entirely. It would otherwise fail
# (backup_retention_period = 0, no backup selection), but the scope filter means
# it is never evaluated and therefore passes.
resource "aws_db_instance" "out_of_scope_by_id_db" {
  attrs = {
    identifier              = "other-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:other-db"
    backup_retention_period = 0
    backup_window           = "09:46-10:16"
    tags                    = {}
  }
}
