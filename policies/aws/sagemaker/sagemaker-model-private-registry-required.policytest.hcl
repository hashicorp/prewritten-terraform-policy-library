policytest {
  targets = [
    "sagemaker-model-private-registry-required.policy.hcl"
  ]
}
// pass_1: Model with VPC mode and complete configuration
resource "aws_sagemaker_model" "pass_vpc_with_auth" {
  attrs = {
    name               = "test-model-vpc-auth"
    execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerRole"
    primary_container = [{
      image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-model:latest"
      image_config = [{
        repository_access_mode = "Vpc"
        repository_auth_config = [{
          repository_credentials_provider_arn = "arn:aws:lambda:us-east-1:123456789012:function:docker-credentials"
        }]
      }]
    }]
  }
}

// pass_2: Model with VPC mode without authentication (public VPC registry)
resource "aws_sagemaker_model" "pass_vpc_no_auth" {
  attrs = {
    name               = "test-model-vpc-no-auth"
    execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerRole"
    primary_container = [{
      image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-model:latest"
      image_config = [{
        repository_access_mode = "Vpc"
      }]
    }]
  }
}

// ============================================================================
// FAIL SCENARIOS
// ============================================================================

// fail_1: Model without image_config
resource "aws_sagemaker_model" "fail_no_image_config" {
  expect_failure = true
  attrs = {
    name               = "test-model-no-config"
    execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerRole"
    primary_container = [{
      image = "763104351884.dkr.ecr.us-east-1.amazonaws.com/pytorch-inference:1.5.0-cpu-py3"
    }]
  }
}

// fail_2: Model with Platform mode
resource "aws_sagemaker_model" "fail_platform_mode" {
  expect_failure = true
  attrs = {
    name               = "test-model-platform"
    execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerRole"
    primary_container = [{
      image = "763104351884.dkr.ecr.us-east-1.amazonaws.com/pytorch-inference:1.5.0-cpu-py3"
      image_config = [{
        repository_access_mode = "Platform"
      }]
    }]
  }
}

// fail_3: Model with empty repository_access_mode
resource "aws_sagemaker_model" "fail_empty_mode" {
  expect_failure = true
  attrs = {
    name               = "test-model-empty-mode"
    execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerRole"
    primary_container = [{
      image = "763104351884.dkr.ecr.us-east-1.amazonaws.com/pytorch-inference:1.5.0-cpu-py3"
      image_config = [{
        repository_access_mode = ""
      }]
    }]
  }
}

// edge_1: Model with VPC mode but incomplete auth_config
resource "aws_sagemaker_model" "fail_incomplete_auth" {
  expect_failure = true
  attrs = {
    name               = "test-model-incomplete-auth"
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

resource "aws_sagemaker_model" "skip_no_primary_container" {
  attrs = {
    name               = "test-model-multi-container"
    execution_role_arn = "arn:aws:iam::123456789012:role/SageMakerRole"
    container = [{
      image = "763104351884.dkr.ecr.us-east-1.amazonaws.com/pytorch-inference:1.5.0-cpu-py3"
    }]
  }
}