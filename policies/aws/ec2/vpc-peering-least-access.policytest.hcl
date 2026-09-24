# Copyright IBM Corp. 2026

policytest {
  targets = ["vpc-peering-least-access.policy.hcl"]
}

# ──────────────────────────────────────────────────────────────
# PASS cases
# ──────────────────────────────────────────────────────────────

# Test 1: PASS - peering route with specific IPv4 CIDR (least access)
resource "aws_route" "pass_specific_cidr" {
  attrs = {
    route_table_id            = "rtb-12345678"
    destination_cidr_block    = "10.1.0.0/24"
    vpc_peering_connection_id = "pcx-12345678"
  }
}

# Test 2: PASS - peering route with specific /16 IPv4 CIDR
resource "aws_route" "pass_specific_16_cidr" {
  attrs = {
    route_table_id            = "rtb-22345678"
    destination_cidr_block    = "192.168.0.0/16"
    vpc_peering_connection_id = "pcx-22345678"
  }
}

# Test 3: PASS - peering route with specific IPv6 CIDR
resource "aws_route" "pass_specific_ipv6_cidr" {
  attrs = {
    route_table_id                  = "rtb-32345678"
    destination_ipv6_cidr_block     = "2001:db8::/32"
    vpc_peering_connection_id       = "pcx-32345678"
  }
}

# Test 4: PASS - non-peering route with 0.0.0.0/0 (not evaluated — no peering ID)
resource "aws_route" "pass_non_peering_route" {
  attrs = {
    route_table_id         = "rtb-42345678"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "igw-12345678"
  }
}

# Test 5: PASS - non-peering route without vpc_peering_connection_id (skipped by filter)
resource "aws_route" "pass_no_peering_id" {
  attrs = {
    route_table_id         = "rtb-52345678"
    destination_cidr_block = "10.0.0.0/8"
  }
}

# ──────────────────────────────────────────────────────────────
# FAIL cases
# ──────────────────────────────────────────────────────────────

# Test 6: FAIL - peering route with catch-all IPv4 CIDR 0.0.0.0/0
resource "aws_route" "fail_catch_all_ipv4" {
  expect_failure = true
  attrs = {
    route_table_id            = "rtb-62345678"
    destination_cidr_block    = "0.0.0.0/0"
    vpc_peering_connection_id = "pcx-62345678"
  }
}

# Test 7: FAIL - peering route with catch-all IPv6 CIDR ::/0
resource "aws_route" "fail_catch_all_ipv6" {
  expect_failure = true
  attrs = {
    route_table_id                  = "rtb-72345678"
    destination_ipv6_cidr_block     = "::/0"
    vpc_peering_connection_id       = "pcx-72345678"
  }
}
