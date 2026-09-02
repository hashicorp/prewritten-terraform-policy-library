# Copyright IBM Corp. 2026

policytest {
    targets = [
        "sagemaker-model-private-registry-required.policy.hcl"
    ]
}

# Test 1: PASS - primary_container with image_config and valid repository_credentials_provider_arn
resource "aws_sagemaker_model" "pass_vpc_mode_with_valid_credentials" {
  attrs = {
    name               = "compliant-model-vpc-registry"
    execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerRole"
    primary_container = [{
      image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-model:latest"
      image_config = [{
        repository_access_mode = "Vpc"
        repository_auth_config = [{
          repository_credentials_provider_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-credentials-provider"
        }]
      }]
    }]
  }
}

# Test 2: FAIL - primary_container with image_config and repository_auth_config but credentials_arn is empty
resource "aws_sagemaker_model" "fail_vpc_mode_empty_credentials_arn" {
  expect_failure = true
  attrs = {
    name               = "non-compliant-model-empty-arn"
    execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerRole"
    primary_container = [{
      image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-model:latest"
      image_config = [{
        repository_access_mode = "Vpc"
        repository_auth_config = [{
          repository_credentials_provider_arn = ""
        }]
      }]
    }]
  }
}

# Test 3: FAIL - primary_container with image_config but no repository_auth_config (credentials_arn defaults to "")
resource "aws_sagemaker_model" "fail_no_auth_config" {
  expect_failure = true
  attrs = {
    name               = "non-compliant-model-no-auth"
    execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerRole"
    primary_container = [{
      image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-model:latest"
      image_config = [{
        repository_access_mode = "Vpc"
      }]
    }]
  }
}

# Test 4: FAIL - primary_container with no image_config (image_config = [] → auth_config_list = [] → credentials_arn = "")
resource "aws_sagemaker_model" "fail_no_image_config" {
  expect_failure = true
  attrs = {
    name               = "non-compliant-model-no-image-config"
    execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerRole"
    primary_container = [{
      image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-model:latest"
    }]
  }
}

# Test 5: FAIL - no primary_container (primary_container = [] → credentials_arn = "")
resource "aws_sagemaker_model" "fail_no_primary_container" {
  expect_failure = true
  attrs = {
    name               = "non-compliant-model-no-primary-container"
    execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerRole"
    container = [{
      image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-model:latest"
    }]
  }
}

# Test 6: FAIL - primary_container with Platform access mode and no auth config (credentials_arn = "")
resource "aws_sagemaker_model" "fail_platform_access_mode" {
  expect_failure = true
  attrs = {
    name               = "non-compliant-model-platform-mode"
    execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerRole"
    primary_container = [{
      image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-model:latest"
      image_config = [{
        repository_access_mode = "Platform"
      }]
    }]
  }
}
