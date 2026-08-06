# VPC flow logging should be enabled in all VPCs

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether Amazon VPC Flow Logs are found and enabled for VPCs. The traffic type is set to Reject. The control fails if VPC Flow Logs aren't enabled for VPCs in your account.

This control doesn't check whether Amazon VPC Flow Logs are enabled through Amazon Security Lake for the AWS account.

With the VPC Flow Logs feature, you can capture information about the IP address traffic going to and from network interfaces in your VPC. After you create a flow log, you can view and retrieve its data in CloudWatch Logs. To reduce cost, you can also send your flow logs to Amazon S3.

Security Hub CSPM recommends that you enable flow logging for packet rejects for VPCs. Flow logs provide visibility into network traffic that traverses the VPC and can detect anomalous traffic or provide insight during security workflows.

By default, the record includes values for the different components of the IP address flow, including the source, destination, and protocol. For more information and descriptions of the log fields, see VPC Flow Logs in the Amazon VPC User Guide.

This rule is covered by the [vpc-flow-logs-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/vpc-flow-logs-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # vpc-flow-logs-enabled.policytest.hcl...
      running
      # resource.aws_flow_log.reject_flow_log...
      running
      # resource.aws_flow_log.reject_flow_log...
      pass
      # resource.aws_vpc.vpc_with_reject_logging...
      running
      # resource.aws_vpc.vpc_with_reject_logging...
      pass
      # resource.aws_flow_log.all_flow_log...
      running
      # resource.aws_flow_log.all_flow_log...
      pass
      # resource.aws_vpc.vpc_with_all_logging...
      running
      # resource.aws_vpc.vpc_with_all_logging...
      pass
      # resource.aws_vpc.vpc_without_logging...
      running
      # resource.aws_vpc.vpc_without_logging...
      pass
      # resource.aws_flow_log.accept_flow_log...
      running
      # resource.aws_flow_log.accept_flow_log...
      pass
      # resource.aws_vpc.vpc_with_accept_only...
      running
      # resource.aws_vpc.vpc_with_accept_only...
      pass
      # vpc-flow-logs-enabled.policytest.hcl...
      pass
```

---
