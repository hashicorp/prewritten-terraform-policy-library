policytest {
  targets = [
    "ssm-document-not-public.policy.hcl"
  ]
}

<<<<<<< HEAD
// Test 1: PASS - Self-owned document with no permissions configured
=======
# Test 1: PASS - Self-owned document with no permissions configured
>>>>>>> origin/main
resource "aws_ssm_document" "pass_no_permissions" {
  attrs = {
    name          = "test-document-no-perms"
    document_type = "Command"
    content       = "{\"schemaVersion\":\"2.2\",\"description\":\"Test\"}"
    owner         = "Self"
    permissions   = null
  }
}

<<<<<<< HEAD
// Test 2: PASS - Self-owned document with specific account IDs (not 'All')
=======
# Test 2: PASS - Self-owned document with specific account IDs (not 'All')
>>>>>>> origin/main
resource "aws_ssm_document" "pass_specific_accounts" {
  attrs = {
    name          = "test-document-specific"
    document_type = "Command"
    content       = "{\"schemaVersion\":\"2.2\",\"description\":\"Test\"}"
    owner         = "Self"
    permissions = {
      type        = "Share"
      account_ids = ["123456789012", "987654321098"]
    }
  }
}

<<<<<<< HEAD
// Test 3: FAIL - Self-owned document with 'All' in account_ids (public)
=======
# Test 3: FAIL - Self-owned document with 'All' in account_ids (public)
>>>>>>> origin/main
resource "aws_ssm_document" "fail_public_document" {
  expect_failure = true
  attrs = {
    name          = "test-document-public"
    document_type = "Command"
    content       = "{\"schemaVersion\":\"2.2\",\"description\":\"Test\"}"
    owner         = "Self"
    permissions = {
      type        = "Share"
      account_ids = ["All"]
    }
  }
}

<<<<<<< HEAD
// Test 4: PASS - Document not owned by Self (filtered out)
=======
# Test 4: PASS - Document not owned by Self (filtered out)
>>>>>>> origin/main
resource "aws_ssm_document" "pass_not_self_owned" {
  attrs = {
    name          = "AWS-RunShellScript"
    document_type = "Command"
    content       = "{\"schemaVersion\":\"2.2\",\"description\":\"AWS Managed\"}"
    owner         = "Amazon"
    permissions = {
      type        = "Share"
      account_ids = ["All"]
    }
  }
}

<<<<<<< HEAD
// Test 5: PASS - Self-owned document with empty account_ids list
=======
# Test 5: PASS - Self-owned document with empty account_ids list
>>>>>>> origin/main
resource "aws_ssm_document" "pass_empty_account_ids" {
  attrs = {
    name          = "test-document-empty"
    document_type = "Command"
    content       = "{\"schemaVersion\":\"2.2\",\"description\":\"Test\"}"
    owner         = "Self"
    permissions = {
      type        = "Share"
      account_ids = []
    }
  }
}

<<<<<<< HEAD
// Test 6: FAIL - Self-owned document with 'All' mixed with specific accounts
=======
# Test 6: FAIL - Self-owned document with 'All' mixed with specific accounts
>>>>>>> origin/main
resource "aws_ssm_document" "fail_all_with_specific" {
  expect_failure = true
  attrs = {
    name          = "test-document-mixed"
    document_type = "Command"
    content       = "{\"schemaVersion\":\"2.2\",\"description\":\"Test\"}"
    owner         = "Self"
    permissions = {
      type        = "Share"
      account_ids = ["123456789012", "All"]
    }
  }
}