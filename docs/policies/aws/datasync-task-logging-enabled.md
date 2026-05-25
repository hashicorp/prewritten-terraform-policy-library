# DataSync tasks should have logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an AWS DataSync task has logging enabled. The control fails if the task doesn't have logging enabled.

Audit logs track and monitor system activities. They provide a record of events that can help you detect security breaches, investigate incidents, and comply with regulations. Audit logs also enhance the overall accountability and transparency of your organization.

This rule is covered by the [datasync-task-logging-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/datasync/datasync-task-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # datasync-task-logging-enabled.policytest.hcl...
      running
      # resource.aws_datasync_task.pass_with_basic_logging...
      running
      # resource.aws_datasync_task.pass_with_basic_logging...
      pass
      # resource.aws_datasync_task.pass_with_transfer_logging...
      running
      # resource.aws_datasync_task.pass_with_transfer_logging...
      pass
      # resource.aws_datasync_task.fail_with_log_level_off...
      running
      # resource.aws_datasync_task.fail_with_log_level_off...
      pass
      # resource.aws_datasync_task.fail_without_log_group...
      running
      # resource.aws_datasync_task.fail_without_log_group...
      pass
      # resource.aws_datasync_task.fail_with_default_log_level...
      running
      # resource.aws_datasync_task.fail_with_default_log_level...
      pass
      # resource.aws_datasync_task.fail_with_empty_log_group...
      running
      # resource.aws_datasync_task.fail_with_empty_log_group...
      pass
      # datasync-task-logging-enabled.policytest.hcl...
      pass
```

---
