policytest {
  targets = ["elastic-beanstalk-logs-to-cloudwatch.policy.hcl"]
}

<<<<<<< HEAD
// Test 1: Pass - Environment with CloudWatch Logs streaming enabled
=======
# Test 1: Pass - Environment with CloudWatch Logs streaming enabled
>>>>>>> origin/main
resource "aws_elastic_beanstalk_environment" "pass_with_cloudwatch_logs_enabled" {
  attrs = {
    name = "my-environment"
    application = "my-app"
    solution_stack_name = "64bit Amazon Linux 2 v3.4.0 running Python 3.8"
    setting = [
      {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name = "StreamLogs"
        value = "true"
        resource = ""
      },
      {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "InstanceType"
        value = "t2.micro"
        resource = ""
      }
    ]
  }
}

<<<<<<< HEAD
// Test 2: Fail - Environment without CloudWatch Logs configuration
=======
# Test 2: Fail - Environment without CloudWatch Logs configuration
>>>>>>> origin/main
resource "aws_elastic_beanstalk_environment" "fail_without_cloudwatch_logs_configuration" {
  expect_failure = true
  attrs = {
    name = "my-environment"
    application = "my-app"
    solution_stack_name = "64bit Amazon Linux 2 v3.4.0 running Python 3.8"
    setting = [
      {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "InstanceType"
        value = "t2.micro"
        resource = ""
      }
    ]
  }
}

<<<<<<< HEAD
// Test 3: Fail - Environment with CloudWatch Logs streaming disabled
=======
# Test 3: Fail - Environment with CloudWatch Logs streaming disabled
>>>>>>> origin/main
resource "aws_elastic_beanstalk_environment" "fail_with_cloudwatch_logs_disabled" {
  expect_failure = true
  attrs = {
    name = "my-environment"
    application = "my-app"
    solution_stack_name = "64bit Amazon Linux 2 v3.4.0 running Python 3.8"
    setting = [
      {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name = "StreamLogs"
        value = "false"
        resource = ""
      }
    ]
  }
}

<<<<<<< HEAD
// Test 4: Pass - Environment with valid retention period
=======
# Test 4: Pass - Environment with valid retention period
>>>>>>> origin/main
resource "aws_elastic_beanstalk_environment" "pass_with_valid_retention_period" {
  attrs = {
    name = "my-environment"
    application = "my-app"
    solution_stack_name = "64bit Amazon Linux 2 v3.4.0 running Python 3.8"
    setting = [
      {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name = "StreamLogs"
        value = "true"
        resource = ""
      },
      {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name = "RetentionInDays"
        value = "30"
        resource = ""
      }
    ]
  }
}

<<<<<<< HEAD
// Test 5: Fail - Environment with invalid retention period
=======
# Test 5: Fail - Environment with invalid retention period
>>>>>>> origin/main
resource "aws_elastic_beanstalk_environment" "fail_with_invalid_retention_period" {
  expect_failure = true
  attrs = {
    name = "my-environment"
    application = "my-app"
    solution_stack_name = "64bit Amazon Linux 2 v3.4.0 running Python 3.8"
    setting = [
      {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name = "StreamLogs"
        value = "true"
        resource = ""
      },
      {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name = "RetentionInDays"
        value = "45"
        resource = ""
      }
    ]
  }
}

<<<<<<< HEAD
// Test 6: Fail - Environment with only other settings configured
=======
# Test 6: Fail - Environment with only other settings configured
>>>>>>> origin/main
resource "aws_elastic_beanstalk_environment" "fail_with_only_other_settings" {
  expect_failure = true
  attrs = {
    name = "my-environment"
    application = "my-app"
    solution_stack_name = "64bit Amazon Linux 2 v3.4.0 running Python 3.8"
    setting = [
      {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "InstanceType"
        value = "t2.micro"
        resource = ""
      },
      {
        namespace = "aws:elasticbeanstalk:environment"
        name = "EnvironmentType"
        value = "LoadBalanced"
        resource = ""
      }
    ]
  }
}
