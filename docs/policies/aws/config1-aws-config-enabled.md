# AWS Config should be enabled and use the service-linked role for resource recording

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Inventory |

## Description

## Parameters

| Parameter | Description | Type | Allowed custom values | Security Hub CSPM default value |
| --------- | ----------- | ---- | --------------------- | ------------------------------- |
| includeConfigServiceLinkedRoleCheck | The control does not evaluate whether AWS Config uses the service-linked role if the parameter is set to `false`. | Boolean | `true` or `false` | `true` |  

This control checks whether AWS Config is enabled in your account in the current AWS Region, records all resources that correspond to controls enabled in the current Region, and uses the service-linked AWS Config role. The service-linked role name is `AWSServiceRoleForConfig`. If you do not use the service-linked role and do not set `includeConfigServiceLinkedRoleCheck` to `false`, the control fails because other roles might not have the permissions that AWS Config needs to accurately record resources.

The control also verifies that the configuration recorder is enabled, records supported resources appropriately, and is backed by a delivery channel so AWS Config can continuously capture and deliver configuration state.

AWS Config performs configuration management for supported AWS resources in your account and delivers log files for those configuration changes. The recorded information includes the configuration item, relationships between configuration items, and configuration changes over time. Global resources are resources that are available in any Region.

This rule is covered by the [config1-aws-config-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/config/config1-aws-config-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # config1-aws-config-enabled.policytest.hcl...
      running
      # resource.aws_config_configuration_recorder.pass_complete_configuration...
      running
      # resource.aws_config_configuration_recorder.pass_complete_configuration...
      pass
      # resource.aws_config_configuration_recorder.fail_all_supported_false...
      running
      # resource.aws_config_configuration_recorder.fail_all_supported_false...
      pass
      # resource.aws_config_configuration_recorder_status.pass_status_enabled...
      running
      # resource.aws_config_configuration_recorder_status.pass_status_enabled...
      pass
      # resource.aws_config_delivery_channel.fail_no_s3_bucket...
      running
      # resource.aws_config_delivery_channel.fail_no_s3_bucket...
      pass
      # config1-aws-config-enabled.policytest.hcl...
      pass
```

---