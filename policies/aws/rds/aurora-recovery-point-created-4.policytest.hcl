# Copyright IBM Corp. 2026

# Separate file: assumes inputs.resource_id = "some-other-cluster-id" (does not match
# this file's cluster), so this file requires its own inputs {} block distinct from the
# default-inputs files.
policytest {
  targets = ["aurora-recovery-point-created.policy.hcl"]
}

inputs {
  aurora-recovery-point-created-resource_id = "some-other-cluster-id"
}

# PASS (out of scope): resource_id filter excludes this cluster even though
# backup_retention_period is 0 and no AWS Backup plan exists.
resource "aws_rds_cluster" "pass_resource_id_filter_excludes_cluster" {
  attrs = {
    cluster_identifier      = "aurora-cluster-8"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-8"
  }
}
