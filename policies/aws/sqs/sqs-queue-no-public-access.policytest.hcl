# Copyright IBM Corp. 2026

policytest {
  targets = [
    "sqs-queue-no-public-access.policy.hcl"
  ]
}

# ======================== PASS cases ========================

# Test 1: PASS - Queue with standalone policy restricted to specific AWS account
resource "aws_sqs_queue" "pass_specific_account_principal" {
  attrs = {
    name = "my-queue"
  }
}
resource "aws_sqs_queue_policy" "pass_specific_account_principal" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:root\"},\"Action\":\"sqs:*\",\"Resource\":\"*\"}]}"
  }
}

# Test 2: PASS - Queue with no policy at all (private by default)
resource "aws_sqs_queue" "pass_no_policy" {
  attrs = {
    name = "my-private-queue"
  }
}

# Test 3: PASS - Wildcard principal but Deny effect (not public access)
resource "aws_sqs_queue" "pass_wildcard_deny_effect" {
  attrs = {
    name = "my-deny-queue"
  }
}
resource "aws_sqs_queue_policy" "pass_wildcard_deny_effect" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-deny-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":\"*\",\"Action\":\"sqs:*\",\"Resource\":\"*\"}]}"
  }
}

# Test 4: PASS - Wildcard principal but restrictive Condition present
resource "aws_sqs_queue" "pass_wildcard_with_condition" {
  attrs = {
    name = "my-conditioned-queue"
  }
}
resource "aws_sqs_queue_policy" "pass_wildcard_with_condition" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-conditioned-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\",\"Condition\":{\"ArnEquals\":{\"aws:SourceArn\":\"arn:aws:sns:us-east-1:123456789012:my-topic\"}}}]}"
  }
}

# Test 5: PASS - Single-object Statement with specific principal
resource "aws_sqs_queue" "pass_single_object_statement_specific" {
  attrs = {
    name = "my-single-stmt-queue"
  }
}
resource "aws_sqs_queue_policy" "pass_single_object_statement_specific" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-single-stmt-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:root\"},\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}}"
  }
}

# ======================== FAIL cases ========================

# Test 6: FAIL - Wildcard (*) as Principal string
resource "aws_sqs_queue" "fail_wildcard_principal" {
  expect_failure = true
  attrs = {
    name = "my-public-queue"
  }
}
resource "aws_sqs_queue_policy" "fail_wildcard_principal" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-public-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}]}"
  }
}

# Test 7: FAIL - Wildcard (*) in Principal.AWS string
resource "aws_sqs_queue" "fail_wildcard_principal_aws" {
  expect_failure = true
  attrs = {
    name = "my-public-aws-queue"
  }
}
resource "aws_sqs_queue_policy" "fail_wildcard_principal_aws" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-public-aws-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"*\"},\"Action\":\"sqs:ReceiveMessage\",\"Resource\":\"*\"}]}"
  }
}

# Test 8: FAIL - Wildcard principal in list form {"AWS": ["*"]}
resource "aws_sqs_queue" "fail_wildcard_aws_principal_list" {
  expect_failure = true
  attrs = {
    name = "my-list-wildcard-queue"
  }
}
resource "aws_sqs_queue_policy" "fail_wildcard_aws_principal_list" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-list-wildcard-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":[\"*\"]},\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}]}"
  }
}

# Test 9: FAIL - Wildcard in mixed list {"AWS": ["arn:...:root", "*"]}
resource "aws_sqs_queue" "fail_wildcard_aws_principal_mixed_list" {
  expect_failure = true
  attrs = {
    name = "my-mixed-wildcard-queue"
  }
}
resource "aws_sqs_queue_policy" "fail_wildcard_aws_principal_mixed_list" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-mixed-wildcard-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":[\"arn:aws:iam::123456789012:root\",\"*\"]},\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}]}"
  }
}

# Test 10: FAIL - NotPrincipal with Effect: Allow is effectively public
resource "aws_sqs_queue" "fail_not_principal_allow" {
  expect_failure = true
  attrs = {
    name = "my-notprincipal-queue"
  }
}
resource "aws_sqs_queue_policy" "fail_not_principal_allow" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-notprincipal-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"NotPrincipal\":{\"AWS\":\"arn:aws:iam::123456789012:root\"},\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}]}"
  }
}

# Test 11: FAIL - Single-object Statement with wildcard principal
resource "aws_sqs_queue" "fail_single_object_statement_wildcard" {
  expect_failure = true
  attrs = {
    name = "my-single-wildcard-queue"
  }
}
resource "aws_sqs_queue_policy" "fail_single_object_statement_wildcard" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-single-wildcard-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}}"
  }
}

# Test 12: FAIL - Wildcard Service principal
resource "aws_sqs_queue" "fail_wildcard_service_principal" {
  expect_failure = true
  attrs = {
    name = "my-service-wildcard-queue"
  }
}
resource "aws_sqs_queue_policy" "fail_wildcard_service_principal" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-service-wildcard-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"*\"},\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}]}"
  }
}
