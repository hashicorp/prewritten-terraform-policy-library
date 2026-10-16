# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-security-group-attached-to-eni-periodic.policy.hcl"]
}

resource "aws_network_interface" "eni_for_sg_eni_001" {
  skip = true
  attrs = {
    subnet_id       = "subnet-0000000000000001"
    security_groups = ["sg-eni-001"]
  }
}

resource "aws_network_interface" "eni_multi_sg" {
  skip = true
  attrs = {
    subnet_id       = "subnet-0000000000000001"
    security_groups = ["sg-other-100", "sg-multi-eni-006"]
  }
}

resource "aws_network_interface" "eni_empty_sg_list" {
  skip = true
  attrs = {
    subnet_id       = "subnet-0000000000000001"
    security_groups = []
  }
}

resource "aws_network_interface_sg_attachment" "attachment_for_sg_att_002" {
  skip = true
  attrs = {
    security_group_id    = "sg-att-002"
    network_interface_id = "eni-0000000000000002"
  }
}

resource "aws_network_interface_sg_attachment" "attachment_null_sg_id" {
  skip = true
  attrs = {
    security_group_id    = null
    network_interface_id = "eni-0000000000000099"
  }
}

resource "aws_instance" "instance_for_sg_inst_003" {
  skip = true
  attrs = {
    ami                    = "ami-0123456789abcdef0"
    instance_type          = "t3.micro"
    vpc_security_group_ids = ["sg-inst-003"]
  }
}

resource "aws_instance" "instance_multi_sg" {
  skip = true
  attrs = {
    ami                    = "ami-0123456789abcdef0"
    instance_type          = "t3.micro"
    vpc_security_group_ids = ["sg-other-200", "sg-multi-inst-007"]
  }
}

resource "aws_instance" "instance_null_sg_ids" {
  skip = true
  attrs = {
    ami                    = "ami-0123456789abcdef0"
    instance_type          = "t3.micro"
    vpc_security_group_ids = null
  }
}

# PASS: attached via eni
resource "aws_security_group" "attached_via_eni" {
  attrs = {
    id     = "sg-eni-001"
    name   = "sg-eni-001"
    vpc_id = "vpc-0000000000000001"
  }
}

# PASS: attached via an explicit aws_network_interface_sg_attachment resource
resource "aws_security_group" "attached_via_attachment" {
  attrs = {
    id     = "sg-att-002"
    name   = "sg-att-002"
    vpc_id = "vpc-0000000000000001"
  }
}

# PASS: attached via an aws_instance's vpc_security_group_ids list
resource "aws_security_group" "attached_via_instance" {
  attrs = {
    id     = "sg-inst-003"
    name   = "sg-inst-003"
    vpc_id = "vpc-0000000000000001"
  }
}

# PASS: attached via an ENI that references multiple security groups
resource "aws_security_group" "attached_via_eni_multi" {
  attrs = {
    id     = "sg-multi-eni-006"
    name   = "sg-multi-eni-006"
    vpc_id = "vpc-0000000000000001"
  }
}

# PASS: attached via an instance that references multiple security groups
resource "aws_security_group" "attached_via_instance_multi" {
  attrs = {
    id     = "sg-multi-inst-007"
    name   = "sg-multi-inst-007"
    vpc_id = "vpc-0000000000000001"
  }
}

# FAIL: unattached
resource "aws_security_group" "unattached" {
  expect_failure = true
  attrs = {
    id     = "sg-unattached-004"
    name   = "sg-unattached-004"
    vpc_id = "vpc-0000000000000001"
  }
}

# FAIL: aws_security_group with id omitted
resource "aws_security_group" "missing_id" {
  expect_failure = true
  attrs = {
    name   = "sg-missing-id"
    vpc_id = "vpc-0000000000000001"
  }
}

# PASS: used by rds
resource "aws_security_group" "pass_used_by_rds_f2" {
  attrs = { id = "sg-rds0001", name = "rds" }
}

resource "aws_db_instance" "db_f2" {
  attrs = { identifier = "db", instance_class = "db.t3.micro", vpc_security_group_ids = ["sg-rds0001"] }
}

# PASS: used by lambda
resource "aws_security_group" "pass_used_by_lambda_f2" {
  attrs = { id = "sg-lambda01", name = "lambda" }
}

resource "aws_lambda_function" "fn_f2" {
  attrs = {
    function_name = "fn"
    role          = "arn:aws:iam::123456789012:role/fn"
    vpc_config    = [{ security_group_ids = ["sg-lambda01"], subnet_ids = ["subnet-1"] }]
  }
}

# PASS: used by alb
resource "aws_security_group" "pass_used_by_alb_f2" {
  attrs = { id = "sg-alb0001", name = "alb" }
}

resource "aws_lb" "alb_f2" {
  attrs = { name = "alb", security_groups = ["sg-alb0001"] }
}

# FAIL: used by nothing
resource "aws_security_group" "fail_used_by_nothing_f2" {
  attrs          = { id = "sg-unused01", name = "unused" }
  expect_failure = true
}
