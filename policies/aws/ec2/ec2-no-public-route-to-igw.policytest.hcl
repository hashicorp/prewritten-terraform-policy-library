# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-no-public-route-to-igw.policy.hcl"]
}

# Default inputs file: uses the policy's default `allowed_route_table_ids = []`
# (no exemptions). The exemption scenario (allowed_route_table_ids containing a
# specific route table id) requires a different inputs{} value and lives in
# ec2-no-public-route-to-igw-2.policytest.hcl instead.

# FAIL: unrestricted IPv4 route (0.0.0.0/0) targeting an Internet Gateway
resource "aws_route_table" "fail_public_ipv4_route_to_igw" {
  expect_failure = true
  attrs = {
    id     = "rtb-0aaa111111111111"
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

# FAIL: unrestricted IPv6 route (::/0) targeting an Internet Gateway
resource "aws_route_table" "fail_public_ipv6_route_to_igw" {
  expect_failure = true
  attrs = {
    id     = "rtb-0bbb222222222222"
    vpc_id = "vpc-0123456789abcdef0"
    route = [
      {
        ipv6_cidr_block = "::/0"
        gateway_id      = "igw-0123456789abcdef0"
      }
    ]
    tags = {}
  }
}

# PASS: route to an Internet Gateway, but destination is a restricted CIDR (not 0.0.0.0/0)
resource "aws_route_table" "pass_restricted_cidr_to_igw" {
  attrs = {
    id     = "rtb-0ccc333333333333"
    vpc_id = "vpc-0123456789abcdef0"
    route = [
      {
        cidr_block = "10.0.0.0/16"
        gateway_id = "igw-0123456789abcdef0"
      }
    ]
    tags = {}
  }
}

# PASS: unrestricted destination (0.0.0.0/0), but target is a NAT Gateway, not an IGW
resource "aws_route_table" "pass_unrestricted_cidr_to_nat_gateway" {
  attrs = {
    id     = "rtb-0ddd444444444444"
    vpc_id = "vpc-0123456789abcdef0"
    route = [
      {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = "nat-0123456789abcdef0"
      }
    ]
    tags = {}
  }
}

# PASS: route attribute entirely omitted (no routes to inspect)
resource "aws_route_table" "pass_no_routes" {
  attrs = {
    id     = "rtb-0eee555555555555"
    vpc_id = "vpc-0123456789abcdef0"
    tags   = {}
  }
}

# PASS: route attribute explicitly set to an empty set/list
resource "aws_route_table" "pass_empty_route_set" {
  attrs = {
    id     = "rtb-0fff666666666666"
    vpc_id = "vpc-0123456789abcdef0"
    route  = []
    tags   = {}
  }
}

# FAIL: multiple routes, only one of which is a public unrestricted route to an IGW
resource "aws_route_table" "fail_multiple_routes_one_violating" {
  expect_failure = true
  attrs = {
    id     = "rtb-0ggg777777777777"
    vpc_id = "vpc-0123456789abcdef0"
    route = [
      {
        cidr_block     = "10.0.0.0/16"
        nat_gateway_id = "nat-0123456789abcdef0"
      },
      {
        cidr_block = "0.0.0.0/0"
        gateway_id = "igw-0123456789abcdef0"
      }
    ]
    tags = {}
  }
}

# PASS: gateway_id is set but does not start with "igw-" (e.g. a Virtual Private Gateway,
# which also populates the gateway_id field but is not an Internet Gateway)
resource "aws_route_table" "pass_gateway_id_not_igw_prefix" {
  attrs = {
    id     = "rtb-0hhh888888888888"
    vpc_id = "vpc-0123456789abcdef0"
    route = [
      {
        cidr_block = "0.0.0.0/0"
        gateway_id = "vgw-0123456789abcdef0"
      }
    ]
    tags = {}
  }
}

# ---- Cases merged from ec2-no-public-route-to-igw-2.policytest.hcl ----


# FAIL: same violating route shape, but this route table's id is NOT in the allowed list,
# confirming the exemption only applies to the listed id (not a global bypass).
resource "aws_route_table" "fail_not_in_allowed_list_f2" {
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

# ---- Cases merged from ec2-no-public-route-to-igw-3.policytest.hcl ----

resource "aws_route" "fail_ipv4_route_to_igw_f3" {
  attrs = {
    route_table_id         = "rtb-route1"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "igw-0123456789abcdef0"
  }
  expect_failure = true
}

resource "aws_route" "fail_ipv6_route_to_igw_f3" {
  attrs = {
    route_table_id              = "rtb-route2"
    destination_ipv6_cidr_block = "::/0"
    gateway_id                  = "igw-0123456789abcdef0"
  }
  expect_failure = true
}

resource "aws_route" "pass_restricted_cidr_to_igw_f3" {
  attrs = {
    route_table_id         = "rtb-route3"
    destination_cidr_block = "10.0.0.0/16"
    gateway_id             = "igw-0123456789abcdef0"
  }
}

resource "aws_route" "pass_default_route_to_nat_f3" {
  attrs = {
    route_table_id         = "rtb-route4"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = "nat-0123456789abcdef0"
  }
}
