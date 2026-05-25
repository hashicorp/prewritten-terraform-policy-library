# RDS DB instances should not be deployed in public subnets with routes to internet gateways

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether an Amazon RDS DB instance is deployed in a public subnet that has a route to an internet gateway. The control fails if the RDS DB instance is deployed in a subnet that has a route to an internet gateway and the destination is set to 0.0.0.0/0 or ::/0.

By provisioning your Amazon RDS resources in private subnets, you can prevent your RDS resources from receiving inbound traffic from the public internet, which can prevent unintended access to your RDS DB instances. If RDS resources are provisioned in a public subnet that is open to the internet, they might be vulnerable to risks such as data exfiltration.

This rule is covered by the [rds-instance-subnet-igw-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-instance-subnet-igw-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-instance-subnet-igw-check.policytest.hcl... running
      # resource.aws_db_instance.pass_not_publicly_accessible... running
      # resource.aws_db_instance.pass_not_publicly_accessible... pass
      # resource.aws_db_instance.fail_publicly_accessible... running
      # resource.aws_db_instance.fail_publicly_accessible... pass
      # resource.aws_db_instance.pass_default_not_public... running
      # resource.aws_db_instance.pass_default_not_public... pass
      # resource.aws_db_instance.pass_no_subnet_group_filtered... running
      # resource.aws_db_instance.pass_no_subnet_group_filtered... pass
      # rds-instance-subnet-igw-check.policytest.hcl... pass
```

---
