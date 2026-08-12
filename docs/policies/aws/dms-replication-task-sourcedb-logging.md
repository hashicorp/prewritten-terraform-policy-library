# DMS replication tasks for the source database should have logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether logging is enabled with the minimum severity level of LOGGER_SEVERITY_DEFAULT for DMS replication tasks SOURCE_CAPTURE and SOURCE_UNLOAD. The control fails if logging isn't enabled for these tasks or if the minimum severity level is less than LOGGER_SEVERITY_DEFAULT.

DMS uses Amazon CloudWatch to log information during the migration process. Using logging task settings, you can specify which component activities are logged and how much information is logged. You should specify logging for the following tasks:

SOURCE_CAPTURE – Ongoing replication or change data capture (CDC) data is captured from the source database or service, and passed to the SORTER service component.

SOURCE_UNLOAD – Data is unloaded from the source database or service during full load.

Logging plays a critical role in DMS replication tasks by enabling monitoring, troubleshooting, auditing, performance analysis, error detection, and recovery, as well as historical analysis and reporting. It helps ensure the successful replication of data between databases while maintaining data integrity and compliance with regulatory requirements. Logging levels other than DEFAULT are rarely needed for these components during troubleshooting. We recommend keeping the logging level as DEFAULT for these components unless specifically requested to change it by Support. A minimal logging level of DEFAULT ensures that informational messages, warnings, and error messages are written to the logs. This control checks if the logging level is at least one of the following for the preceding replication tasks: LOGGER_SEVERITY_DEFAULT, LOGGER_SEVERITY_DEBUG, or LOGGER_SEVERITY_DETAILED_DEBUG.

This rule is covered by the [dms-replication-task-sourcedb-logging](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/dms/dms-replication-task-sourcedb-logging.policy.hcl) policy.

## Policy Results

```bash
trace:
      # dms-replication-task-sourcedb-logging.policytest.hcl...
      running
      # resource.aws_dms_replication_task.pass_with_settings...
      running
      # resource.aws_dms_replication_task.pass_with_settings...
      pass
      # resource.aws_dms_replication_task.pass_with_minimal_settings...
      running
      # resource.aws_dms_replication_task.pass_with_minimal_settings...
      pass
      # resource.aws_dms_replication_task.fail_no_settings...
      running
      # resource.aws_dms_replication_task.fail_no_settings...
      pass
      # dms-replication-task-sourcedb-logging.policytest.hcl...
      pass
```

---
