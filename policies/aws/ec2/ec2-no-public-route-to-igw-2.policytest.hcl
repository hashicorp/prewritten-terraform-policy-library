# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-no-public-route-to-igw.policy.hcl"]
}

# Separate file: this scenario requires overriding the policy's `allowed_route_table_ids`
# input to a non-default, non-empty value (see testcase_gen.md 4.2 case 1 — a file can
# only hold one inputs{} block, and the default-inputs file already uses the empty-list
# default).
inputs {
  ec2-no-public-route-to-igw-allowed_route_table_ids = ["rtb-0exempted123456"]
}

# PASS: route table has a public unrestricted route to an IGW, but its id is explicitly
# exempted via the allowed_route_table_ids input.
resource "aws_route_table" "pass_exempted_route_table" {
  attrs = {
    id     = "rtb-0exempted123456"
    vpc_id = "vpc-0123456789abcdef0"
    route = [
      {
        cidr_block = "0.0.0.0/0"
        gateway_id = "igw-0123456789abcdef0"
      }
    ]
    tags = {}
  }
}

# FAIL: same violating route shape, but this route table's id is NOT in the allowed list,
# confirming the exemption only applies to the listed id (not a global bypass).
resource "aws_route_table" "fail_not_in_allowed_list" {
  expect_failure = true
  attrs = {
    id     = "rtb-0notexempted9999"
    vpc_id = "vpc-0123456789abcdef0"
    route = [
      {
        cidr_block = "0.0.0.0/0"
        gateway_id = "igw-0123456789abcdef0"
      }
    ]
    tags = {}
  }
}
