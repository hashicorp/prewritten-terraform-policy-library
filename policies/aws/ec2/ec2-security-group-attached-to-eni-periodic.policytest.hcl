# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-security-group-attached-to-eni-periodic.policy.hcl"]
}

# --- Companion resources that establish "attached" relationships ---------

# ENI referencing sg-eni-001 directly in its security_groups list.
resource "aws_network_interface" "eni_for_sg_eni_001" {
  skip = true
  attrs = {
    subnet_id       = "subnet-0000000000000001"
    security_groups = ["sg-eni-001"]
  }
}

# ENI with multiple security groups, one of which is sg-multi-eni-006.
resource "aws_network_interface" "eni_multi_sg" {
  skip = true
  attrs = {
    subnet_id       = "subnet-0000000000000001"
    security_groups = ["sg-other-100", "sg-multi-eni-006"]
  }
}

# ENI with an empty security_groups list - must not crash the policy and
# must not count as a match for any security group.
resource "aws_network_interface" "eni_empty_sg_list" {
  skip = true
  attrs = {
    subnet_id       = "subnet-0000000000000001"
    security_groups = []
  }
}

# Explicit security-group-to-ENI attachment resource for sg-att-002.
resource "aws_network_interface_sg_attachment" "attachment_for_sg_att_002" {
  skip = true
  attrs = {
    security_group_id    = "sg-att-002"
    network_interface_id = "eni-0000000000000002"
  }
}

# Attachment resource with security_group_id explicitly null - verifies the
# two-step null-safety normalization does not crash the policy.
resource "aws_network_interface_sg_attachment" "attachment_null_sg_id" {
  skip = true
  attrs = {
    security_group_id    = null
    network_interface_id = "eni-0000000000000099"
  }
}

# EC2 instance referencing sg-inst-003 via vpc_security_group_ids.
resource "aws_instance" "instance_for_sg_inst_003" {
  skip = true
  attrs = {
    ami                    = "ami-0123456789abcdef0"
    instance_type          = "t3.micro"
    vpc_security_group_ids = ["sg-inst-003"]
  }
}

# EC2 instance with multiple security groups, one of which is sg-multi-inst-007.
resource "aws_instance" "instance_multi_sg" {
  skip = true
  attrs = {
    ami                    = "ami-0123456789abcdef0"
    instance_type          = "t3.micro"
    vpc_security_group_ids = ["sg-other-200", "sg-multi-inst-007"]
  }
}

# EC2 instance with vpc_security_group_ids explicitly null - verifies the
# two-step null-safety normalization does not crash the policy.
resource "aws_instance" "instance_null_sg_ids" {
  skip = true
  attrs = {
    ami                     = "ami-0123456789abcdef0"
    instance_type           = "t3.micro"
    vpc_security_group_ids  = null
  }
}

# --- aws_security_group resources under test ------------------------------

# PASS: attached directly via an aws_network_interface's security_groups list.
resource "aws_security_group" "attached_via_eni" {
  attrs = {
    id     = "sg-eni-001"
    name   = "sg-eni-001"
    vpc_id = "vpc-0000000000000001"
  }
}

# PASS: attached via an explicit aws_network_interface_sg_attachment resource.
resource "aws_security_group" "attached_via_attachment" {
  attrs = {
    id     = "sg-att-002"
    name   = "sg-att-002"
    vpc_id = "vpc-0000000000000001"
  }
}

# PASS: attached via an aws_instance's vpc_security_group_ids list.
resource "aws_security_group" "attached_via_instance" {
  attrs = {
    id     = "sg-inst-003"
    name   = "sg-inst-003"
    vpc_id = "vpc-0000000000000001"
  }
}

# PASS: attached via an ENI that references multiple security groups.
resource "aws_security_group" "attached_via_eni_multi" {
  attrs = {
    id     = "sg-multi-eni-006"
    name   = "sg-multi-eni-006"
    vpc_id = "vpc-0000000000000001"
  }
}

# PASS: attached via an instance that references multiple security groups.
resource "aws_security_group" "attached_via_instance_multi" {
  attrs = {
    id     = "sg-multi-inst-007"
    name   = "sg-multi-inst-007"
    vpc_id = "vpc-0000000000000001"
  }
}

# FAIL: no aws_network_interface, aws_network_interface_sg_attachment, or
# aws_instance resource references this security group's id anywhere in the
# plan - even though OTHER, unrelated security groups ARE referenced by the
# companion resources declared above.
resource "aws_security_group" "unattached" {
  expect_failure = true
  attrs = {
    id     = "sg-unattached-004"
    name   = "sg-unattached-004"
    vpc_id = "vpc-0000000000000001"
  }
}

# FAIL (missing attribute edge case): aws_security_group with id omitted.
# core::try(attrs.id, "") normalizes to "", which cannot match any companion
# reference, so the security group is correctly reported as unattached.
resource "aws_security_group" "missing_id" {
  expect_failure = true
  attrs = {
    name   = "sg-missing-id"
    vpc_id = "vpc-0000000000000001"
  }
}
