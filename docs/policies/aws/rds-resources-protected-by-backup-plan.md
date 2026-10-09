# RDS DB instances should be protected by a backup plan

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Backups enabled |

## Description

Parameters:

| Parameter | Description | Type | Allowed custom values | Security Hub CSPM default value |
| --------- | ----------- | ---- | --------------------- | -------------------------------- |
| backupVaultLockCheck | When set to true, additionally verifies that the AWS Backup vault associated with the backup plan protecting the RDS instance has Vault Lock enabled | String | true, false | false |

This control evaluates if Amazon RDS DB instances are covered by a backup plan. This control fails if the RDS DB instance isn't covered by a backup plan. If you set the backupVaultLockCheck parameter equal to true, the control passes only if the instance is backed up in an AWS Backup locked vault.

AWS Backup is a fully managed backup service that centralizes and automates the backing up of data across AWS services. With AWS Backup, you can create backup policies called backup plans. You can use these plans to define your backup requirements, such as how frequently to back up your data and how long to retain those backups. Including RDS DB instances in a backup plan helps you protect your data from unintended loss or deletion.

This rule is covered by the [rds-resources-protected-by-backup-plan](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-resources-protected-by-backup-plan.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-resources-protected-by-backup-plan-tag.policytest.hcl... running
      # resource.aws_db_instance.pass_tag_based_coverage... running
      # resource.aws_db_instance.pass_tag_based_coverage... pass
      # resource.aws_db_instance.pass_condition_based_coverage... running
      # resource.aws_db_instance.pass_condition_based_coverage... pass
      # resource.aws_db_instance.pass_null_resources_with_tag_fallback... running
      # resource.aws_db_instance.pass_null_resources_with_tag_fallback... pass
      # resource.aws_db_instance.pass_multiple_selections... running
      # resource.aws_db_instance.pass_multiple_selections... pass
      # rds-resources-protected-by-backup-plan-tag.policytest.hcl... pass

      # rds-resources-protected-by-backup-plan.policytest.hcl... running
      # resource.aws_db_instance.pass_direct_arn_coverage... running
      # resource.aws_db_instance.pass_direct_arn_coverage... pass
      # resource.aws_db_instance.fail_no_backup_selection... running
      # resource.aws_db_instance.fail_no_backup_selection... pass
      # resource.aws_db_instance.fail_arn_not_in_selection... running
      # resource.aws_db_instance.fail_arn_not_in_selection... pass
      # resource.aws_db_instance.fail_null_arn_no_coverage... running
      # resource.aws_db_instance.fail_null_arn_no_coverage... pass
      # rds-resources-protected-by-backup-plan.policytest.hcl... pass
```

---