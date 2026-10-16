# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-security-group-attached-to-eni-periodic.policy.hcl"]
}

resource "aws_security_group" "pass_used_by_rds" {
  attrs = { id = "sg-rds0001", name = "rds" }
}

resource "aws_db_instance" "db" {
  attrs = { identifier = "db", instance_class = "db.t3.micro", vpc_security_group_ids = ["sg-rds0001"] }
}

resource "aws_security_group" "pass_used_by_lambda" {
  attrs = { id = "sg-lambda01", name = "lambda" }
}

resource "aws_lambda_function" "fn" {
  attrs = {
    function_name = "fn"
    role          = "arn:aws:iam::123456789012:role/fn"
    vpc_config    = [{ security_group_ids = ["sg-lambda01"], subnet_ids = ["subnet-1"] }]
  }
}

resource "aws_security_group" "pass_used_by_alb" {
  attrs = { id = "sg-alb0001", name = "alb" }
}

resource "aws_lb" "alb" {
  attrs = { name = "alb", security_groups = ["sg-alb0001"] }
}

resource "aws_security_group" "fail_used_by_nothing" {
  attrs = { id = "sg-unused01", name = "unused" }
  expect_failure = true
}
