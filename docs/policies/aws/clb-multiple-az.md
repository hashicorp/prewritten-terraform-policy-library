# Classic Load Balancer should span multiple Availability Zones

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control checks whether a Classic Load Balancer has been configured to span at least the specified number of Availability Zones (AZs). The control fails if the Classic Load Balancer does not span at least the specified number of AZs. Unless you provide a custom parameter value for the minimum number of AZs, Security Hub CSPM uses a default value of two AZs.

A Classic Load Balancer can be set up to distribute incoming requests across Amazon EC2 instances in a single Availability Zone or multiple Availability Zones. A Classic Load Balancer that does not span multiple Availability Zones is unable to redirect traffic to targets in another Availability Zone if the sole configured Availability Zone becomes unavailable.

This rule is covered by the [clb-multiple-az](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elb/clb-multiple-az.policy.hcl) policy.

## Policy Results

```bash
trace:
      # clb-multiple-az.policytest.hcl... running
      # resource.aws_elb.pass_ec2_classic_2_azs... running
      # resource.aws_elb.pass_ec2_classic_2_azs... pass
      # resource.aws_elb.pass_ec2_classic_3_azs... running
      # resource.aws_elb.pass_ec2_classic_3_azs... pass
      # resource.aws_elb.fail_ec2_classic_1_az... running
      # resource.aws_elb.fail_ec2_classic_1_az... pass
      # resource.aws_elb.pass_vpc_2_subnets... running
      # resource.aws_elb.pass_vpc_2_subnets... pass
      # resource.aws_elb.pass_vpc_3_subnets... running
      # resource.aws_elb.pass_vpc_3_subnets... pass
      # resource.aws_elb.fail_vpc_1_subnet... running
      # resource.aws_elb.fail_vpc_1_subnet... pass
      # clb-multiple-az.policytest.hcl... pass
```

---
