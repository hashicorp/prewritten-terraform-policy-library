# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-non-default-security-groups-attached-to-eni.policy.hcl"]
}

# PASS: security group id appears in an aws_network_interface.security_groups list
resource "aws_security_group" "pass_via_eni" {
  attrs = {
    id          = "sg-00001"
    name        = "pass-via-eni"
    description = "test security group"
    vpc_id      = "vpc-12345678"
  }
}

resource "aws_network_interface" "eni_for_pass" {
  skip = true
  attrs = {
    id              = "eni-00001"
    subnet_id       = "subnet-12345678"
    security_groups = ["sg-00001"]
  }
}

# PASS: security group id matches an aws_network_interface_sg_attachment.security_group_id
resource "aws_security_group" "pass_via_attachment" {
  attrs = {
    id          = "sg-00002"
    name        = "pass-via-attachment"
    description = "test security group"
    vpc_id      = "vpc-12345678"
  }
}

resource "aws_network_interface_sg_attachment" "attachment_for_pass" {
  skip = true
  attrs = {
    security_group_id    = "sg-00002"
    network_interface_id = "eni-00002"
  }
}

# PASS: security group id appears in an aws_instance.vpc_security_group_ids list
resource "aws_security_group" "pass_via_instance" {
  attrs = {
    id          = "sg-00003"
    name        = "pass-via-instance"
    description = "test security group"
    vpc_id      = "vpc-12345678"
  }
}

resource "aws_instance" "instance_for_pass" {
  skip = true
  attrs = {
    id                     = "i-00003"
    ami                    = "ami-12345678"
    instance_type          = "t3.micro"
    subnet_id              = "subnet-12345678"
    vpc_security_group_ids = ["sg-00003"]
  }
}

# FAIL: no attachment
resource "aws_security_group" "fail_no_attachment" {
  expect_failure = true
  attrs = {
    id          = "sg-00004"
    name        = "fail-no-attachment"
    description = "test security group"
    vpc_id      = "vpc-12345678"
  }
}

# FAIL: wrong eni reference
resource "aws_security_group" "fail_wrong_eni_reference" {
  expect_failure = true
  attrs = {
    id          = "sg-00005"
    name        = "fail-wrong-eni-reference"
    description = "test security group"
    vpc_id      = "vpc-12345678"
  }
}

resource "aws_network_interface" "eni_for_fail" {
  skip = true
  attrs = {
    id              = "eni-00005"
    subnet_id       = "subnet-12345678"
    security_groups = ["sg-99999"]
  }
}

# FAIL: empty instance list
resource "aws_security_group" "fail_empty_instance_list" {
  expect_failure = true
  attrs = {
    id          = "sg-00006"
    name        = "fail-empty-instance-list"
    description = "test security group"
    vpc_id      = "vpc-12345678"
  }
}

resource "aws_instance" "instance_empty_list" {
  skip = true
  attrs = {
    id                     = "i-00006"
    ami                    = "ami-12345678"
    instance_type          = "t3.micro"
    subnet_id              = "subnet-12345678"
    vpc_security_group_ids = []
  }
}

# FAIL: an aws_network_interface exists but omits the security_groups attribute entirely
resource "aws_security_group" "fail_missing_sg_attribute" {
  expect_failure = true
  attrs = {
    id          = "sg-00007"
    name        = "fail-missing-sg-attribute"
    description = "test security group"
    vpc_id      = "vpc-12345678"
  }
}

resource "aws_network_interface" "eni_missing_sg_attr" {
  skip = true
  attrs = {
    id        = "eni-00007"
    subnet_id = "subnet-12345678"
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
