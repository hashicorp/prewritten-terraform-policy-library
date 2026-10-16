# Copyright IBM Corp. 2026

# Separate file: assumes inputs.recovery_point_age_unit = "hours" and
# inputs.recovery_point_age_value = 1 (a stricter, hourly requirement), requiring its
# own inputs {} block distinct from the default-inputs (days-based) files.
policytest {
  targets = ["aurora-recovery-point-created.policy.hcl"]
}

inputs {
  aurora-recovery-point-created-recovery_point_age_unit  = "hours"
  aurora-recovery-point-created-recovery_point_age_value = 1
}

# PASS: required coverage window is 1 hour; 1 day (24h) of backup_retention_period
# comfortably covers it.
resource "aws_rds_cluster" "pass_hourly_requirement_satisfied_by_daily_retention" {
  attrs = {
    cluster_identifier      = "aurora-cluster-10"
    engine                  = "aurora-mysql"
    backup_retention_period = 1
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-10"
  }
}
