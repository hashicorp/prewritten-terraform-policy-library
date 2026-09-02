# Copyright IBM Corp. 2026

policytest {
  targets = [
    "codebuild-project-source-repo-url-check.policy.hcl"
  ]
}

# Test 1: PASS - Bitbucket primary source with clean URL (no embedded credentials)
resource "aws_codebuild_project" "pass_bitbucket_clean_url" {
  attrs = {
    name = "test-project-bitbucket-clean"
    source = [{
      type     = "BITBUCKET"
      location = "https://bitbucket.org/myorg/myrepo"
    }]
  }
}

# Test 2: FAIL - Bitbucket primary source with embedded user:password credentials
resource "aws_codebuild_project" "fail_bitbucket_embedded_password" {
  expect_failure = true
  attrs = {
    name = "test-project-bitbucket-embedded-password"
    source = [{
      type     = "BITBUCKET"
      location = "https://myuser:mypassword@bitbucket.org/myorg/myrepo"
    }]
  }
}

# Test 3: FAIL - Bitbucket primary source with embedded user:token credentials
resource "aws_codebuild_project" "fail_bitbucket_embedded_token" {
  expect_failure = true
  attrs = {
    name = "test-project-bitbucket-embedded-token"
    source = [{
      type     = "BITBUCKET"
      location = "https://myuser:myaccesstoken@bitbucket.org/myorg/myrepo"
    }]
  }
}

# Test 4: PASS - GitHub primary source with embedded credentials (not BITBUCKET, not checked)
resource "aws_codebuild_project" "pass_github_embedded_url" {
  attrs = {
    name = "test-project-github-embedded"
    source = [{
      type     = "GITHUB"
      location = "https://myuser:mytoken@github.com/myorg/myrepo"
    }]
  }
}

# Test 5: PASS - No source attribute set
resource "aws_codebuild_project" "pass_no_source" {
  attrs = {
    name = "test-project-no-source"
  }
}

# Test 6: PASS - Bitbucket primary clean URL, Bitbucket secondary clean URL
resource "aws_codebuild_project" "pass_primary_and_secondary_clean" {
  attrs = {
    name = "test-project-both-clean"
    source = [{
      type     = "BITBUCKET"
      location = "https://bitbucket.org/myorg/primary-repo"
    }]
    secondary_sources = [
      {
        source_identifier = "secondary-bb"
        type              = "BITBUCKET"
        location          = "https://bitbucket.org/myorg/secondary-repo"
      }
    ]
  }
}

# Test 7: FAIL - Bitbucket secondary source with embedded credentials
resource "aws_codebuild_project" "fail_secondary_embedded_credentials" {
  expect_failure = true
  attrs = {
    name = "test-project-secondary-embedded"
    source = [{
      type     = "BITBUCKET"
      location = "https://bitbucket.org/myorg/primary-repo"
    }]
    secondary_sources = [
      {
        source_identifier = "secondary-bb"
        type              = "BITBUCKET"
        location          = "https://myuser:mytoken@bitbucket.org/myorg/secondary-repo"
      }
    ]
  }
}

# Test 8: PASS - GitHub primary with Bitbucket secondary (secondary clean URL)
resource "aws_codebuild_project" "pass_github_primary_bitbucket_secondary_clean" {
  attrs = {
    name = "test-project-github-primary-bb-secondary"
    source = [{
      type     = "GITHUB"
      location = "https://github.com/myorg/primary-repo"
    }]
    secondary_sources = [
      {
        source_identifier = "secondary-bb"
        type              = "BITBUCKET"
        location          = "https://bitbucket.org/myorg/secondary-repo"
      }
    ]
  }
}

# Test 9: FAIL - GitHub primary (passes first enforce), Bitbucket secondary with embedded credentials
resource "aws_codebuild_project" "fail_github_primary_bb_secondary_embedded" {
  expect_failure = true
  attrs = {
    name = "test-project-github-primary-bb-secondary-embedded"
    source = [{
      type     = "GITHUB"
      location = "https://github.com/myorg/primary-repo"
    }]
    secondary_sources = [
      {
        source_identifier = "secondary-bb"
        type              = "BITBUCKET"
        location          = "https://myuser:mytoken@bitbucket.org/myorg/secondary-repo"
      }
    ]
  }
}
