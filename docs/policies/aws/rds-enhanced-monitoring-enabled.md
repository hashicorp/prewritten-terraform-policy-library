# Enhanced monitoring should be configured for RDS DB instances

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether enhanced monitoring is enabled for an Amazon Relational Database Service (Amazon RDS) DB instance. The control fails if enhanced monitoring isn't enabled for the instance. If you provide a custom value for the monitoringInterval parameter, the control passes only if enhanced monitoring metrics are collected for the instance at the specified interval.

In Amazon RDS, Enhanced Monitoring enables a more rapid response to performance changes in underlying infrastructure. These performance changes could result in a lack of availability of the data. Enhanced Monitoring provides real-time metrics of the operating system that your RDS DB instance runs on. An agent is installed on the instance. The agent can obtain metrics more accurately than is possible from the hypervisor layer.

Enhanced Monitoring metrics are useful when you want to see how different processes or threads on a DB instance use the CPU. For more information, see Enhanced Monitoring in the Amazon RDS User Guide.

This rule is covered by the [rds-enhanced-monitoring-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-enhanced-monitoring-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-enhanced-monitoring-enabled.policytest.hcl... running
      # resource.aws_db_instance.pass_monitoring_60... running
      # resource.aws_db_instance.pass_monitoring_60... pass
      # resource.aws_db_instance.pass_monitoring_1... running
      # resource.aws_db_instance.pass_monitoring_1... pass
      # resource.aws_db_instance.fail_monitoring_disabled... running
      # resource.aws_db_instance.fail_monitoring_disabled... pass
      # resource.aws_db_instance.fail_monitoring_missing... running
      # resource.aws_db_instance.fail_monitoring_missing... pass
      # resource.aws_db_instance.fail_monitoring_invalid... running
      # resource.aws_db_instance.fail_monitoring_invalid... pass
      # rds-enhanced-monitoring-enabled.policytest.hcl... pass
```

---
