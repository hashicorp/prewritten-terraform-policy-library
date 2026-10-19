# Copyright IBM Corp. 2026

policytest {
  targets = ["elb-nlb-cross-zone-load-balancing-enabled.policy.hcl"]
}

# PASS: NLB with cross-zone load balancing explicitly enabled
resource "aws_lb" "pass_nlb_cross_zone_enabled" {
  attrs = {
    name                             = "nlb-pass-enabled"
    load_balancer_type               = "network"
    enable_cross_zone_load_balancing = true
  }
}

# FAIL: NLB with cross-zone load balancing explicitly disabled
resource "aws_lb" "fail_nlb_cross_zone_disabled" {
  expect_failure = true
  attrs = {
    name                             = "nlb-fail-disabled"
    load_balancer_type               = "network"
    enable_cross_zone_load_balancing = false
  }
}

# FAIL: NLB with enable_cross_zone_load_balancing attribute entirely omitted (defaults to false)
resource "aws_lb" "fail_nlb_cross_zone_missing" {
  expect_failure = true
  attrs = {
    name               = "nlb-fail-missing"
    load_balancer_type = "network"
    # enable_cross_zone_load_balancing intentionally omitted
  }
}

# FAIL: NLB with enable_cross_zone_load_balancing explicitly set to null (normalized to false)
resource "aws_lb" "fail_nlb_cross_zone_null" {
  expect_failure = true
  attrs = {
    name                             = "nlb-fail-null"
    load_balancer_type               = "network"
    enable_cross_zone_load_balancing = null
  }
}

# PASS: Application Load Balancer is out of scope for this policy regardless of the flag's value
resource "aws_lb" "pass_alb_out_of_scope" {
  attrs = {
    name                             = "alb-pass-out-of-scope"
    load_balancer_type               = "application"
    enable_cross_zone_load_balancing = false
  }
}

# PASS: Gateway Load Balancer is out of scope for this policy regardless of the flag's value
resource "aws_lb" "pass_gwlb_out_of_scope" {
  attrs = {
    name                             = "gwlb-pass-out-of-scope"
    load_balancer_type               = "gateway"
    enable_cross_zone_load_balancing = false
  }
}

# PASS: load_balancer_type entirely omitted defaults to "application", so the NLB check does not apply
resource "aws_lb" "pass_type_omitted_defaults_application" {
  attrs = {
    name = "lb-pass-type-omitted"
    # load_balancer_type intentionally omitted - defaults to "application"
    internal = false
  }
}
