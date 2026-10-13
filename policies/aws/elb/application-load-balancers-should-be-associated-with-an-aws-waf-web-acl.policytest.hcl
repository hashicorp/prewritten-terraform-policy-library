# Copyright IBM Corp. 2026

policytest {
  targets = ["application-load-balancers-should-be-associated-with-an-aws-waf-web-acl.policy.hcl"]
}

resource "aws_wafv2_web_acl_association" "pass_alb" {
  skip = true
  attrs = {
    resource_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/protected/1234567890abcdef"
    web_acl_arn  = "arn:aws:wafv2:us-east-1:123456789012:regional/webacl/test/abc"
  }
}

# PASS: application load balancer has a matching WAFv2 association
resource "aws_lb" "pass_associated_alb" {
  attrs = {
    name               = "protected"
    load_balancer_type = "application"
    arn                = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/protected/1234567890abcdef"
  }
}

# PASS: load_balancer_type defaults to application
resource "aws_wafv2_web_acl_association" "pass_default_type_alb" {
  skip = true
  attrs = {
    resource_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/default-type/abcdef1234567890"
    web_acl_arn  = "arn:aws:wafv2:us-east-1:123456789012:regional/webacl/test/abc"
  }
}

# Association for a separate ALB; ensures the test does not grant coverage to other ALBs.
resource "aws_wafv2_web_acl_association" "other_alb" {
  skip = true
  attrs = {
    resource_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/other/abcdef0123456789"
    web_acl_arn  = "arn:aws:wafv2:us-east-1:123456789012:regional/webacl/test/abc"
  }
}

resource "aws_lb" "pass_default_type_alb" {
  attrs = {
    name = "default-type"
    arn  = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/default-type/abcdef1234567890"
  }
}

# FAIL: application load balancer has no WAF association
resource "aws_lb" "fail_unassociated_alb" {
  expect_failure = true
  attrs = {
    name               = "unprotected"
    load_balancer_type = "application"
    arn                = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/unprotected/abcdef9876543210"
  }
}

# FAIL: only a different load balancer has a WAF association
resource "aws_lb" "pass_second_associated_alb" {
  attrs = {
    name               = "other"
    load_balancer_type = "application"
    arn                = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/other/abcdef0123456789"
  }
}

# SKIP: network load balancers are not covered by this control
resource "aws_lb" "skip_network_load_balancer" {
  attrs = {
    name               = "network"
    load_balancer_type = "network"
    arn                = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/network/1234567890abcdef"
  }
}
