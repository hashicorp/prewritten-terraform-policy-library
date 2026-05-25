policytest {
  targets = ["transfer-family-server-no-ftp.policy.hcl"]
}

<<<<<<< HEAD
// Test 1: Pass - No protocols specified (defaults to SFTP)
=======
# Test 1: Pass - No protocols specified (defaults to SFTP)
>>>>>>> origin/main
resource "aws_transfer_server" "pass_default_sftp" {
  attrs = {
    endpoint_type = "PUBLIC"
    identity_provider_type = "SERVICE_MANAGED"
  }
}

<<<<<<< HEAD
// Test 2: Pass - SFTP protocol only
=======
# Test 2: Pass - SFTP protocol only
>>>>>>> origin/main
resource "aws_transfer_server" "pass_sftp_only" {
  attrs = {
    protocols = ["SFTP"]
    endpoint_type = "PUBLIC"
    identity_provider_type = "SERVICE_MANAGED"
  }
}

<<<<<<< HEAD
// Test 3: Pass - FTPS protocol only
=======
# Test 3: Pass - FTPS protocol only
>>>>>>> origin/main
resource "aws_transfer_server" "pass_ftps_only" {
  attrs = {
    protocols = ["FTPS"]
    endpoint_type = "PUBLIC"
    identity_provider_type = "SERVICE_MANAGED"
    certificate = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234"
  }
}

<<<<<<< HEAD
// Test 4: Pass - AS2 protocol only
=======
# Test 4: Pass - AS2 protocol only
>>>>>>> origin/main
resource "aws_transfer_server" "pass_as2_only" {
  attrs = {
    protocols = ["AS2"]
    endpoint_type = "PUBLIC"
    identity_provider_type = "SERVICE_MANAGED"
  }
}

<<<<<<< HEAD
// Test 5: Pass - Multiple secure protocols (SFTP and FTPS)
=======
# Test 5: Pass - Multiple secure protocols (SFTP and FTPS)
>>>>>>> origin/main
resource "aws_transfer_server" "pass_multiple_secure" {
  attrs = {
    protocols = ["SFTP", "FTPS"]
    endpoint_type = "PUBLIC"
    identity_provider_type = "SERVICE_MANAGED"
    certificate = "arn:aws:acm:us-east-1:123456789012:certificate/abcd1234"
  }
}

<<<<<<< HEAD
// Test 6: Fail - FTP protocol only
=======
# Test 6: Fail - FTP protocol only
>>>>>>> origin/main
resource "aws_transfer_server" "fail_ftp_only" {
  expect_failure = true
  attrs = {
    protocols = ["FTP"]
    endpoint_type = "PUBLIC"
    identity_provider_type = "SERVICE_MANAGED"
  }
}

<<<<<<< HEAD
// Test 7: Fail - FTP with secure protocols (FTP and SFTP)
=======
# Test 7: Fail - FTP with secure protocols (FTP and SFTP)
>>>>>>> origin/main
resource "aws_transfer_server" "fail_ftp_with_secure" {
  expect_failure = true
  attrs = {
    protocols = ["FTP", "SFTP"]
    endpoint_type = "PUBLIC"
    identity_provider_type = "SERVICE_MANAGED"
  }
}