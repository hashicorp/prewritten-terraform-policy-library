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
    id                      = "i-00003"
    ami                     = "ami-12345678"
    instance_type           = "t3.micro"
    subnet_id               = "subnet-12345678"
    vpc_security_group_ids  = ["sg-00003"]
  }
}

# FAIL: no aws_network_interface, aws_network_interface_sg_attachment, or aws_instance
# references this security group anywhere in the plan
resource "aws_security_group" "fail_no_attachment" {
  expect_failure = true
  attrs = {
    id          = "sg-00004"
    name        = "fail-no-attachment"
    description = "test security group"
    vpc_id      = "vpc-12345678"
  }
}

# FAIL: an aws_network_interface exists, but its security_groups list references a
# different security group (sg-99999), not this one
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

# FAIL: an aws_instance exists but its vpc_security_group_ids list is empty, and no
# other resource references this security group
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
    id                      = "i-00006"
    ami                     = "ami-12345678"
    instance_type           = "t3.micro"
    subnet_id               = "subnet-12345678"
    vpc_security_group_ids  = []
  }
}

# FAIL: an aws_network_interface exists but omits the security_groups attribute
# entirely; policy must not crash and must correctly treat this as not attached
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
