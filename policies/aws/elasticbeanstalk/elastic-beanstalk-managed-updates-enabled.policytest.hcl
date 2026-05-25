policytest {
    targets = ["elastic-beanstalk-managed-updates-enabled.policy.hcl"]
}

<<<<<<< HEAD
// Test 1: PASS - Environment with managed updates enabled
=======
# Test 1: PASS - Environment with managed updates enabled
>>>>>>> origin/main
resource "aws_elastic_beanstalk_environment" "pass_managed_updates_enabled" {
    attrs = {
        name = "test-environment"
        application = "test-app"
        solution_stack_name = "64bit Amazon Linux 2 v5.8.0 running Node.js 18"
        
        setting = [
            {
                namespace = "aws:elasticbeanstalk:managedactions"
                name = "ManagedActionsEnabled"
                value = "true"
            },
            {
                namespace = "aws:elasticbeanstalk:managedactions"
                name = "PreferredStartTime"
                value = "Sun:10:00"
            },
            {
                namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
                name = "UpdateLevel"
                value = "patch"
            }
        ]
    }
}

<<<<<<< HEAD
// Test 2: PASS - Environment with managed updates and update level
=======
# Test 2: PASS - Environment with managed updates and update level
>>>>>>> origin/main
resource "aws_elastic_beanstalk_environment" "pass_managed_updates_with_level" {
    attrs = {
        name = "prod-environment"
        application = "prod-app"
        solution_stack_name = "64bit Amazon Linux 2 v5.8.0 running Node.js 18"
        
        setting = [
            {
                namespace = "aws:elasticbeanstalk:managedactions"
                name = "ManagedActionsEnabled"
                value = "true"
            },
            {
                namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
                name = "UpdateLevel"
                value = "minor"
            }
        ]
    }
}

<<<<<<< HEAD
// Test 3: FAIL - Environment without managed updates configuration
=======
# Test 3: FAIL - Environment without managed updates configuration
>>>>>>> origin/main
resource "aws_elastic_beanstalk_environment" "fail_no_managed_updates" {
    expect_failure = true
    
    attrs = {
        name = "test-environment-no-updates"
        application = "test-app"
        solution_stack_name = "64bit Amazon Linux 2 v5.8.0 running Node.js 18"
        
        setting = [
            {
                namespace = "aws:autoscaling:launchconfiguration"
                name = "InstanceType"
                value = "t3.micro"
            }
        ]
    }
}

<<<<<<< HEAD
// Test 4: FAIL - Environment with managed updates explicitly disabled
=======
# Test 4: FAIL - Environment with managed updates explicitly disabled
>>>>>>> origin/main
resource "aws_elastic_beanstalk_environment" "fail_managed_updates_disabled" {
    expect_failure = true
    
    attrs = {
        name = "test-environment-disabled"
        application = "test-app"
        solution_stack_name = "64bit Amazon Linux 2 v5.8.0 running Node.js 18"
        
        setting = [
            {
                namespace = "aws:elasticbeanstalk:managedactions"
                name = "ManagedActionsEnabled"
                value = "false"
            }
        ]
    }
}

<<<<<<< HEAD
// Test 5: FAIL - Environment with empty settings
=======
# Test 5: FAIL - Environment with empty settings
>>>>>>> origin/main
resource "aws_elastic_beanstalk_environment" "fail_empty_settings" {
    expect_failure = true
    
    attrs = {
        name = "test-environment-empty"
        application = "test-app"
        solution_stack_name = "64bit Amazon Linux 2 v5.8.0 running Node.js 18"
        
        setting = []
    }
}
