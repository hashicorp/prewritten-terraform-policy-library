# Copyright IBM Corp. 2026

# Separate file: assumes inputs.resource_tags = "{\"env\":\"prod\"}" (this file's
# cluster does not have a matching "env" tag), requiring its own inputs {} block
# distinct from the default-inputs files.
policytest {
  targets = ["aurora-recovery-point-created.policy.hcl"]
}

inputs {
  aurora-recovery-point-created-resource_tags = "{\"env\":\"prod\"}"
}

# PASS (out of scope): resource_tags filter excludes this cluster (missing "env" tag)
# even though backup_retention_period is 0 and no AWS Backup plan exists.
resource "aws_rds_cluster" "pass_resource_tags_filter_excludes_cluster" {
  attrs = {
    cluster_identifier      = "aurora-cluster-9"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-9"
  }
}
