# GuardDuty RDS Protection should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether GuardDuty RDS Protection is enabled. For a standalone account, the control fails if GuardDuty RDS Protection is disabled in the account. In a multi-account environment, the control fails if the delegated GuardDuty administrator account and all member accounts don't have RDS Protection enabled.

In a multi-account environment, the control generates findings in only the delegated GuardDuty administrator account. Only the delegated administrator can enable or disable the RDS Protection feature for the member accounts in the organization. GuardDuty member accounts can't modify this configuration from their accounts. This control generates FAILED findings if the delegated GuardDuty administrator has a suspended member account that doesn't have GuardDuty RDS Protection enabled. To receive a PASSED finding, the delegated administrator must disassociate these suspended accounts in GuardDuty.

RDS Protection in GuardDuty analyzes and profiles RDS login activity for potential access threats to your Amazon Aurora databases (Aurora MySQL-Compatible Edition and Aurora PostgreSQL-Compatible Edition). This feature allows you to identify potentially suspicious login behavior. RDS Protection doesn't require additional infrastructure; it is designed so as not to affect the performance of your database instances. When RDS Protection detects a potentially suspicious or anomalous login attempt that indicates a threat to your database, GuardDuty generates a new finding with details about the potentially compromised database.

This rule is covered by the [guardduty-rds-protection-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/guardduty/guardduty-rds-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # guardduty-rds-protection-enabled.policytest.hcl... running
      # resource.aws_guardduty_detector_feature.pass_rds_protection_enabled... running
      # resource.aws_guardduty_detector_feature.pass_rds_protection_enabled... pass
      # resource.aws_guardduty_detector_feature.fail_rds_protection_disabled... running
      # resource.aws_guardduty_detector_feature.fail_rds_protection_disabled... pass
      # resource.aws_guardduty_detector_feature.fail_rds_protection_status_missing... running
      # resource.aws_guardduty_detector_feature.fail_rds_protection_status_missing... pass
      # resource.aws_guardduty_organization_configuration_feature.pass_org_rds_protection... running
      # resource.aws_guardduty_organization_configuration_feature.pass_org_rds_protection... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_rds_protection... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_rds_protection... pass
      # resource.aws_guardduty_detector_feature.skip_different_feature... running
      # resource.aws_guardduty_detector_feature.skip_different_feature... pass
      # guardduty-rds-protection-enabled.policytest.hcl... pass
```

---
