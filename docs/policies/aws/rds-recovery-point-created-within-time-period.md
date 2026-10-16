# RDS databases should have a recent recovery point

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Backups enabled |

## Description

This policy checks if a recovery point was created for Amazon Relational Database Service (Amazon RDS). The policy fails if the Amazon RDS instance does not have a corresponding recovery point created within the specified time period.

The policy evaluates `aws_db_instance`, `aws_rds_cluster` resources.

The underlying requirement checks that a recovery point was actually created within the time period. Recovery points are runtime state and are not visible in a Terraform plan, so this policy checks the configuration that produces them. An `aws_db_instance` or `aws_rds_cluster` passes only when **both** conditions hold:

1. **Covered by an AWS Backup selection.** An `aws_backup_selection` in the same plan selects the database, either by ARN in `resources` (exact ARN, a `:*` wildcard, or an ARN ending in the identifier) or by `selection_tag` entries that all match the database's tags. The selection is only counted when its `plan_id` matches an `aws_backup_plan` and its `iam_role_arn` matches an `aws_iam_role` that are also in the plan.
2. **Automated backups enabled.** `backup_retention_period` is greater than 0.

Limitations:
- **Backup plan and IAM role must be in the same plan.** Selections that reference a backup plan or IAM role managed elsewhere are ignored, so the database fails.
- **Values unknown at plan time.** When the database, backup plan or IAM role is created in the same plan, their ARNs and IDs are unknown until apply, so the result can be unknown rather than pass or fail. Tag-based selections avoid this for the database.
- **Schedule not checked.** The backup plan's schedule is not compared with `recovery_point_age_value` / `recovery_point_age_unit`; those inputs only appear in the error message.
- **Scope inputs.** `resource_id` limits the policy to one identifier; `resource_tags` (a map) limits it to databases with all of the given tags.
- **Overlap.** The library's `rds-resources-protected-by-backup-plan` (RDS.26) covers the backup-selection part for `aws_db_instance`.

This rule is covered by the [rds-recovery-point-created-within-time-period](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-recovery-point-created-within-time-period.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      rds-recovery-point-created-within-time-period.policytest.hcl...
      running
      # resource.aws_db_instance.compliant_db...
      running
      # resource.aws_db_instance.compliant_db...
      pass
      # resource.aws_db_instance.no_retention_db...
      running
      # resource.aws_db_instance.no_retention_db...
      pass
      # resource.aws_db_instance.unlinked_db...
      running
      # resource.aws_db_instance.unlinked_db...
      pass
      # resource.aws_db_instance.tag_match_db...
      running
      # resource.aws_db_instance.tag_match_db...
      pass
      # resource.aws_db_instance.partial_tag_db...
      running
      # resource.aws_db_instance.partial_tag_db...
      pass
      # resource.aws_db_instance.bad_plan_db...
      running
      # resource.aws_db_instance.bad_plan_db...
      pass
      # resource.aws_db_instance.bad_role_db...
      running
      # resource.aws_db_instance.bad_role_db...
      pass
      # resource.aws_rds_cluster.compliant_cluster...
      running
      # resource.aws_rds_cluster.compliant_cluster...
      pass
      # resource.aws_rds_cluster.no_retention_cluster...
      running
      # resource.aws_rds_cluster.no_retention_cluster...
      pass
      # resource.aws_rds_cluster.unlinked_cluster...
      running
      # resource.aws_rds_cluster.unlinked_cluster...
      pass
      # resource.aws_db_instance.no_selection_at_all_db_f2...
      running
      # resource.aws_db_instance.no_selection_at_all_db_f2...
      pass
      #
      rds-recovery-point-created-within-time-period.policytest.hcl...
      pass
```

---
