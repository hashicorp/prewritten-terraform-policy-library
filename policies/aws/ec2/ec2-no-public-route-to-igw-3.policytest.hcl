# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-no-public-route-to-igw.policy.hcl"]
}

resource "aws_route" "fail_ipv4_route_to_igw" {
  attrs = {
    route_table_id         = "rtb-route1"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "igw-0123456789abcdef0"
  }
  expect_failure = true
}

resource "aws_route" "fail_ipv6_route_to_igw" {
  attrs = {
    route_table_id              = "rtb-route2"
    destination_ipv6_cidr_block = "::/0"
    gateway_id                  = "igw-0123456789abcdef0"
  }
  expect_failure = true
}

resource "aws_route" "pass_restricted_cidr_to_igw" {
  attrs = {
    route_table_id         = "rtb-route3"
    destination_cidr_block = "10.0.0.0/16"
    gateway_id             = "igw-0123456789abcdef0"
  }
}

resource "aws_route" "pass_default_route_to_nat" {
  attrs = {
    route_table_id         = "rtb-route4"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = "nat-0123456789abcdef0"
  }
}
