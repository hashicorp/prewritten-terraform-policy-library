# Athena workgroups should have logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon Athena workgroup has logging enabled. The control fails if the workgroup doesn't have logging enabled.

Audit logs track and monitor system activities. They provide a record of events that can help you detect security breaches, investigate incidents, and comply with regulations. Audit logs also enhance the overall accountability and transparency of your organization.

This rule is covered by the [athena-workgroup-logging-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/athena/athena-workgroup-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # athena-workgroup-logging-enabled.policytest.hcl... running
      # resource.aws_athena_workgroup.pass_logging_enabled... running
      # resource.aws_athena_workgroup.pass_logging_enabled... pass
      # resource.aws_athena_workgroup.fail_logging_disabled... running
      # resource.aws_athena_workgroup.fail_logging_disabled... pass
      # resource.aws_athena_workgroup.pass_logging_missing_flag... running
      # resource.aws_athena_workgroup.pass_logging_missing_flag... pass
      # resource.aws_athena_workgroup.pass_logging_missing_configuration... running
      # resource.aws_athena_workgroup.pass_logging_missing_configuration... pass
      # athena-workgroup-logging-enabled.policytest.hcl... pass
```

---
