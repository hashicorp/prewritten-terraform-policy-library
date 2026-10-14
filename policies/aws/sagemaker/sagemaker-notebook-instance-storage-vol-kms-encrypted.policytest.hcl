# Copyright IBM Corp. 2026

policytest {
  targets = ["sagemaker-notebook-instance-storage-vol-kms-encrypted.policy.hcl"]
}

# ---- PASS cases ----

resource "aws_sagemaker_notebook_instance" "pass_kms_key_arn" {
  attrs = {
    name          = "pass-arn"
    instance_type = "ml.t3.medium"
    role_arn      = "arn:aws:iam::111122223333:role/sagemaker"
    kms_key_id    = "arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
  }
}

resource "aws_sagemaker_notebook_instance" "pass_kms_key_id" {
  attrs = {
    name          = "pass-id"
    instance_type = "ml.t3.medium"
    role_arn      = "arn:aws:iam::111122223333:role/sagemaker"
    kms_key_id    = "1234abcd-12ab-34cd-56ef-1234567890ab"
  }
}

# ---- FAIL cases ----

resource "aws_sagemaker_notebook_instance" "fail_kms_key_omitted" {
  attrs = {
    name          = "fail-omitted"
    instance_type = "ml.t3.medium"
    role_arn      = "arn:aws:iam::111122223333:role/sagemaker"
  }
  expect_failure = true
}

resource "aws_sagemaker_notebook_instance" "fail_kms_key_null" {
  attrs = {
    name          = "fail-null"
    instance_type = "ml.t3.medium"
    role_arn      = "arn:aws:iam::111122223333:role/sagemaker"
    kms_key_id    = null
  }
  expect_failure = true
}

resource "aws_sagemaker_notebook_instance" "fail_kms_key_empty" {
  attrs = {
    name          = "fail-empty"
    instance_type = "ml.t3.medium"
    role_arn      = "arn:aws:iam::111122223333:role/sagemaker"
    kms_key_id    = "  "
  }
  expect_failure = true
}
