# Transfer Family connectors should have logging enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether Amazon CloudWatch logging is enabled for an AWS Transfer Family connector. The control fails if CloudWatch logging isn't enabled for the connector.

Amazon CloudWatch is a monitoring and observability service that provides visibility into your AWS resources, including AWS Transfer Family resources. For Transfer Family, CloudWatch provides consolidated auditing and logging for workflow progress and results. This includes several metrics that Transfer Family defines for workflows. You can configure Transfer Family to automatically log connector events in CloudWatch. To do this, you specify a logging role for the connector. For the logging role, you create an IAM role and a resource-based IAM policy that defines the permissions for the role.

This rule is covered by the [transfer-connector-logging-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/transfer/transfer-connector-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # transfer-connector-logging-enabled.policytest.hcl...
      running
      # resource.aws_transfer_connector.pass_connector_with_logging_role...
      running
      # resource.aws_transfer_connector.pass_connector_with_logging_role...
      pass
      # resource.aws_transfer_connector.fail_connector_without_logging_role...
      running
      # resource.aws_transfer_connector.fail_connector_without_logging_role...
      pass
      # resource.aws_transfer_connector.fail_connector_with_empty_logging_role...
      running
      # resource.aws_transfer_connector.fail_connector_with_empty_logging_role...
      pass
      # resource.aws_transfer_connector.pass_as2_connector_with_logging...
      running
      # resource.aws_transfer_connector.pass_as2_connector_with_logging...
      pass
      # resource.aws_transfer_connector.pass_sftp_connector_with_logging...
      running
      # resource.aws_transfer_connector.pass_sftp_connector_with_logging...
      pass
      # transfer-connector-logging-enabled.policytest.hcl...
      pass
```

---