# Copyright IBM Corp. 2026

policytest {
  targets = [
    "elasticsearch-logs-to-cloudwatch.policy.hcl"
  ]
}

# Test 1: PASS - ES_APPLICATION_LOGS explicitly enabled with valid CloudWatch log group ARN
resource "aws_elasticsearch_domain" "pass_explicit_enabled" {
  attrs = {
    domain_name    = "compliant-domain"
    elasticsearch_version = "7.10"
    log_publishing_options = [
      {
        log_type                 = "ES_APPLICATION_LOGS"
        enabled                  = true
        cloudwatch_log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/elasticsearch/compliant-domain"
      }
    ]
  }
}

# Test 2: PASS - ES_APPLICATION_LOGS with enabled attribute omitted (defaults to true)
resource "aws_elasticsearch_domain" "pass_enabled_omitted" {
  attrs = {
    domain_name    = "compliant-default-domain"
    elasticsearch_version = "7.10"
    log_publishing_options = [
      {
        log_type                 = "ES_APPLICATION_LOGS"
        cloudwatch_log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/elasticsearch/compliant-default"
      }
    ]
  }
}

# Test 3: FAIL - log_publishing_options is null (no logs configured)
resource "aws_elasticsearch_domain" "fail_null_log_options" {
  expect_failure = true
  attrs = {
    domain_name    = "null-logs-domain"
    elasticsearch_version = "7.10"
    log_publishing_options = null
  }
}

# Test 4: FAIL - log_publishing_options is an empty list
resource "aws_elasticsearch_domain" "fail_empty_log_options" {
  expect_failure = true
  attrs = {
    domain_name    = "empty-logs-domain"
    elasticsearch_version = "7.10"
    log_publishing_options = []
  }
}

# Test 5: FAIL - log_publishing_options[0] is not ES_APPLICATION_LOGS
resource "aws_elasticsearch_domain" "fail_wrong_log_type" {
  expect_failure = true
  attrs = {
    domain_name    = "wrong-log-type-domain"
    elasticsearch_version = "7.10"
    log_publishing_options = [
      {
        log_type                 = "INDEX_SLOW_LOGS"
        enabled                  = true
        cloudwatch_log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/elasticsearch/slow"
      }
    ]
  }
}

# Test 6: FAIL - ES_APPLICATION_LOGS configured but explicitly disabled
resource "aws_elasticsearch_domain" "fail_explicitly_disabled" {
  expect_failure = true
  attrs = {
    domain_name    = "disabled-logging-domain"
    elasticsearch_version = "7.10"
    log_publishing_options = [
      {
        log_type                 = "ES_APPLICATION_LOGS"
        enabled                  = false
        cloudwatch_log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/elasticsearch/disabled"
      }
    ]
  }
}

# Test 7: FAIL - ES_APPLICATION_LOGS enabled but cloudwatch_log_group_arn is empty
resource "aws_elasticsearch_domain" "fail_missing_log_group_arn" {
  expect_failure = true
  attrs = {
    domain_name    = "missing-arn-domain"
    elasticsearch_version = "7.10"
    log_publishing_options = [
      {
        log_type                 = "ES_APPLICATION_LOGS"
        enabled                  = true
        cloudwatch_log_group_arn = ""
      }
    ]
  }
}

# Test 8: PASS - ES_APPLICATION_LOGS is present at a non-zero index
resource "aws_elasticsearch_domain" "fail_app_logs_not_first" {
  attrs = {
    domain_name    = "app-logs-not-first-domain"
    elasticsearch_version = "7.10"
    log_publishing_options = [
      {
        log_type                 = "INDEX_SLOW_LOGS"
        enabled                  = true
        cloudwatch_log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/elasticsearch/slow"
      },
      {
        log_type                 = "ES_APPLICATION_LOGS"
        enabled                  = true
        cloudwatch_log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/elasticsearch/app"
      }
    ]
  }
}
