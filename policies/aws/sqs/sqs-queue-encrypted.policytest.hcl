policytest {
  targets = ["sqs-queue-encrypted.policy.hcl"]
}

<<<<<<< HEAD
// Pass Case 1: SQS queue with SSE-SQS encryption enabled
=======
# Pass Case 1: SQS queue with SSE-SQS encryption enabled
>>>>>>> origin/main
resource "aws_sqs_queue" "pass_sqs_managed_sse" {
  attrs = {
    name                       = "encrypted-queue-sqs"
    sqs_managed_sse_enabled    = true
  }
}

<<<<<<< HEAD
// Pass Case 2: SQS queue with SSE-KMS encryption using KMS key ID
=======
# Pass Case 2: SQS queue with SSE-KMS encryption using KMS key ID
>>>>>>> origin/main
resource "aws_sqs_queue" "pass_kms_key_id" {
  attrs = {
    name                       = "encrypted-queue-kms"
    kms_master_key_id          = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
}

<<<<<<< HEAD
// Pass Case 3: SQS queue with SSE-KMS encryption using KMS key alias
=======
# Pass Case 3: SQS queue with SSE-KMS encryption using KMS key alias
>>>>>>> origin/main
resource "aws_sqs_queue" "pass_kms_alias" {
  attrs = {
    name                       = "encrypted-queue-alias"
    kms_master_key_id          = "alias/aws/sqs"
  }
}

<<<<<<< HEAD
// Pass Case 4: SQS queue with both SSE-SQS and SSE-KMS configured
=======
# Pass Case 4: SQS queue with both SSE-SQS and SSE-KMS configured
>>>>>>> origin/main
resource "aws_sqs_queue" "pass_both_encryption_methods" {
  attrs = {
    name                       = "encrypted-queue-both"
    sqs_managed_sse_enabled    = true
    kms_master_key_id          = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
}

<<<<<<< HEAD
// Fail Case 1: SQS queue without any encryption
=======
# Fail Case 1: SQS queue without any encryption
>>>>>>> origin/main
resource "aws_sqs_queue" "fail_no_encryption" {
  expect_failure = true
  attrs = {
    name = "unencrypted-queue"
  }
}

<<<<<<< HEAD
// Fail Case 2: SQS queue with sqs_managed_sse_enabled explicitly set to false
=======
# Fail Case 2: SQS queue with sqs_managed_sse_enabled explicitly set to false
>>>>>>> origin/main
resource "aws_sqs_queue" "fail_sse_disabled" {
  expect_failure = true
  attrs = {
    name                       = "sse-disabled-queue"
    sqs_managed_sse_enabled    = false
  }
}

<<<<<<< HEAD
// Fail Case 3: SQS queue with empty kms_master_key_id
=======
# Fail Case 3: SQS queue with empty kms_master_key_id
>>>>>>> origin/main
resource "aws_sqs_queue" "fail_empty_kms_key" {
  expect_failure = true
  attrs = {
    name                       = "empty-kms-queue"
    kms_master_key_id          = ""
  }
}