# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-autoscaling-capacity-rebalancing-enabled.policy.hcl"]
}

# PASS: no mixed_instances_policy at all
resource "aws_autoscaling_group" "pass_no_mixed_instances_policy" {
  attrs = {
    name                = "asg-single-type"
    max_size            = 5
    min_size            = 1
    desired_capacity    = 2
    vpc_zone_identifier = ["subnet-0123456789abcdef0"]
    launch_template = [{
      id      = "lt-0123456789abcdef0"
      version = "$Latest"
    }]
  }
}

# PASS: mixed_instances_policy present with a single override and no instance_requirements (single instance type)
resource "aws_autoscaling_group" "pass_single_override_no_requirements" {
  attrs = {
    name                = "asg-single-override"
    max_size            = 5
    min_size            = 1
    desired_capacity    = 2
    vpc_zone_identifier = ["subnet-0123456789abcdef0"]
    capacity_rebalance  = false
    mixed_instances_policy = [{
      launch_template = [{
        launch_template_specification = [{
          launch_template_id = "lt-0123456789abcdef0"
          version            = "$Latest"
        }]
        override = [
          { instance_type = "t3.micro" }
        ]
      }]
    }]
  }
}

# PASS: multiple override entries (explicit multiple instance types) with capacity_rebalance = true
resource "aws_autoscaling_group" "pass_multiple_overrides_rebalance_enabled" {
  attrs = {
    name                = "asg-multi-override-pass"
    max_size            = 5
    min_size            = 1
    desired_capacity    = 2
    vpc_zone_identifier = ["subnet-0123456789abcdef0"]
    capacity_rebalance  = true
    mixed_instances_policy = [{
      launch_template = [{
        launch_template_specification = [{
          launch_template_id = "lt-0123456789abcdef0"
          version            = "$Latest"
        }]
        override = [
          { instance_type = "t3.micro" },
          { instance_type = "t3.small" }
        ]
      }]
    }]
  }
}

# FAIL: multiple override entries (explicit multiple instance types) with capacity_rebalance = false
resource "aws_autoscaling_group" "fail_multiple_overrides_rebalance_disabled" {
  expect_failure = true
  attrs = {
    name                = "asg-multi-override-fail"
    max_size            = 5
    min_size            = 1
    desired_capacity    = 2
    vpc_zone_identifier = ["subnet-0123456789abcdef0"]
    capacity_rebalance  = false
    mixed_instances_policy = [{
      launch_template = [{
        launch_template_specification = [{
          launch_template_id = "lt-0123456789abcdef0"
          version            = "$Latest"
        }]
        override = [
          { instance_type = "t3.micro" },
          { instance_type = "t3.small" }
        ]
      }]
    }]
  }
}

# PASS: instance requirements rebalance enabled
resource "aws_autoscaling_group" "pass_instance_requirements_rebalance_enabled" {
  attrs = {
    name                = "asg-instance-requirements-pass"
    max_size            = 5
    min_size            = 1
    desired_capacity    = 2
    vpc_zone_identifier = ["subnet-0123456789abcdef0"]
    capacity_rebalance  = true
    mixed_instances_policy = [{
      launch_template = [{
        launch_template_specification = [{
          launch_template_id = "lt-0123456789abcdef0"
          version            = "$Latest"
        }]
        override = [
          {
            instance_requirements = [{
              memory_mib = [{
                min = 1024
                max = 4096
              }]
              vcpu_count = [{
                min = 1
                max = 4
              }]
            }]
          }
        ]
      }]
    }]
  }
}

# FAIL: single override entry with instance_requirements (attribute-based selection) with capacity_rebalance = false
resource "aws_autoscaling_group" "fail_instance_requirements_rebalance_disabled" {
  expect_failure = true
  attrs = {
    name                = "asg-instance-requirements-fail"
    max_size            = 5
    min_size            = 1
    desired_capacity    = 2
    vpc_zone_identifier = ["subnet-0123456789abcdef0"]
    capacity_rebalance  = false
    mixed_instances_policy = [{
      launch_template = [{
        launch_template_specification = [{
          launch_template_id = "lt-0123456789abcdef0"
          version            = "$Latest"
        }]
        override = [
          {
            instance_requirements = [{
              memory_mib = [{
                min = 1024
                max = 4096
              }]
              vcpu_count = [{
                min = 1
                max = 4
              }]
            }]
          }
        ]
      }]
    }]
  }
}

# FAIL: multiple overrides rebalance omitted
resource "aws_autoscaling_group" "fail_multiple_overrides_rebalance_omitted" {
  expect_failure = true
  attrs = {
    name                = "asg-multi-override-omitted"
    max_size            = 5
    min_size            = 1
    desired_capacity    = 2
    vpc_zone_identifier = ["subnet-0123456789abcdef0"]
    mixed_instances_policy = [{
      launch_template = [{
        launch_template_specification = [{
          launch_template_id = "lt-0123456789abcdef0"
          version            = "$Latest"
        }]
        override = [
          { instance_type = "t3.micro" },
          { instance_type = "t3.small" }
        ]
      }]
    }]
  }
}
