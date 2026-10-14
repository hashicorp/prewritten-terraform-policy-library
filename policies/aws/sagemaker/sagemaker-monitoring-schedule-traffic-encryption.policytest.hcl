# Copyright IBM Corp. 2026

policytest {
  targets = ["sagemaker-monitoring-schedule-traffic-encryption.policy.hcl"]
}

# ---- PASS cases ----

resource "aws_sagemaker_monitoring_schedule" "pass_inline_encryption_enabled" {
  attrs = {
    name = "pass_inline_encryption_enabled"
    monitoring_schedule_config = [{
      monitoring_type = "DataQuality"
      monitoring_job_definition = [{
        role_arn                     = "arn:aws:iam::111122223333:role/sagemaker"
        monitoring_app_specification = [{ image_uri = "111122223333.dkr.ecr.us-east-1.amazonaws.com/monitor:latest" }]
        monitoring_inputs            = [{ endpoint_input = [{ endpoint_name = "ep", local_path = "/opt/ml/processing/input" }] }]
        monitoring_output_config     = [{ monitoring_outputs = [{ s3_output = [{ local_path = "/opt/ml/processing/output", s3_uri = "s3://bucket/out" }] }] }]
        monitoring_resources         = [{ cluster_config = [{ instance_count = 1, instance_type = "ml.m5.large", volume_size_in_gb = 20 }] }]
        network_config               = [{ enable_inter_container_traffic_encryption = true }]
      }]
    }]
  }
}

resource "aws_sagemaker_data_quality_job_definition" "encrypted_definition" {
  attrs = {
    name           = "dq-encrypted"
    network_config = [{ enable_inter_container_traffic_encryption = true }]
  }
}

resource "aws_sagemaker_monitoring_schedule" "pass_referenced_definition_encrypted" {
  attrs = {
    name = "pass-ref"
    monitoring_schedule_config = [{
      monitoring_type                = "DataQuality"
      monitoring_job_definition_name = "dq-encrypted"
    }]
  }
}

# A definition that is not in the plan cannot be evaluated.
resource "aws_sagemaker_monitoring_schedule" "pass_referenced_definition_outside_plan" {
  attrs = {
    name = "pass-external"
    monitoring_schedule_config = [{
      monitoring_type                = "ModelQuality"
      monitoring_job_definition_name = "defined-elsewhere"
    }]
  }
}

# ---- FAIL cases ----

resource "aws_sagemaker_monitoring_schedule" "fail_inline_encryption_disabled" {
  attrs = {
    name = "fail_inline_encryption_disabled"
    monitoring_schedule_config = [{
      monitoring_type = "DataQuality"
      monitoring_job_definition = [{
        role_arn                     = "arn:aws:iam::111122223333:role/sagemaker"
        monitoring_app_specification = [{ image_uri = "111122223333.dkr.ecr.us-east-1.amazonaws.com/monitor:latest" }]
        monitoring_inputs            = [{ endpoint_input = [{ endpoint_name = "ep", local_path = "/opt/ml/processing/input" }] }]
        monitoring_output_config     = [{ monitoring_outputs = [{ s3_output = [{ local_path = "/opt/ml/processing/output", s3_uri = "s3://bucket/out" }] }] }]
        monitoring_resources         = [{ cluster_config = [{ instance_count = 1, instance_type = "ml.m5.large", volume_size_in_gb = 20 }] }]
        network_config               = [{ enable_inter_container_traffic_encryption = false }]
      }]
    }]
  }
  expect_failure = true
}

resource "aws_sagemaker_monitoring_schedule" "fail_inline_network_config_omitted" {
  attrs = {
    name = "fail_inline_network_config_omitted"
    monitoring_schedule_config = [{
      monitoring_type = "DataQuality"
      monitoring_job_definition = [{
        role_arn                     = "arn:aws:iam::111122223333:role/sagemaker"
        monitoring_app_specification = [{ image_uri = "111122223333.dkr.ecr.us-east-1.amazonaws.com/monitor:latest" }]
        monitoring_inputs            = [{ endpoint_input = [{ endpoint_name = "ep", local_path = "/opt/ml/processing/input" }] }]
        monitoring_output_config     = [{ monitoring_outputs = [{ s3_output = [{ local_path = "/opt/ml/processing/output", s3_uri = "s3://bucket/out" }] }] }]
        monitoring_resources         = [{ cluster_config = [{ instance_count = 1, instance_type = "ml.m5.large", volume_size_in_gb = 20 }] }]
      }]
    }]
  }
  expect_failure = true
}

resource "aws_sagemaker_monitoring_schedule" "fail_inline_flag_omitted" {
  attrs = {
    name = "fail_inline_flag_omitted"
    monitoring_schedule_config = [{
      monitoring_type = "DataQuality"
      monitoring_job_definition = [{
        role_arn                     = "arn:aws:iam::111122223333:role/sagemaker"
        monitoring_app_specification = [{ image_uri = "111122223333.dkr.ecr.us-east-1.amazonaws.com/monitor:latest" }]
        monitoring_inputs            = [{ endpoint_input = [{ endpoint_name = "ep", local_path = "/opt/ml/processing/input" }] }]
        monitoring_output_config     = [{ monitoring_outputs = [{ s3_output = [{ local_path = "/opt/ml/processing/output", s3_uri = "s3://bucket/out" }] }] }]
        monitoring_resources         = [{ cluster_config = [{ instance_count = 1, instance_type = "ml.m5.large", volume_size_in_gb = 20 }] }]
        network_config               = [{ enable_network_isolation = true }]
      }]
    }]
  }
  expect_failure = true
}

resource "aws_sagemaker_data_quality_job_definition" "unencrypted_definition" {
  attrs = {
    name           = "dq-unencrypted"
    network_config = [{ enable_inter_container_traffic_encryption = false }]
  }
}

resource "aws_sagemaker_monitoring_schedule" "fail_referenced_definition_unencrypted" {
  attrs = {
    name = "fail-ref"
    monitoring_schedule_config = [{
      monitoring_type                = "DataQuality"
      monitoring_job_definition_name = "dq-unencrypted"
    }]
  }
  expect_failure = true
}

resource "aws_sagemaker_data_quality_job_definition" "definition_without_network_config" {
  attrs = {
    name = "dq-no-network-config"
  }
}

resource "aws_sagemaker_monitoring_schedule" "fail_referenced_definition_network_config_omitted" {
  attrs = {
    name = "fail-ref-no-network-config"
    monitoring_schedule_config = [{
      monitoring_type                = "DataQuality"
      monitoring_job_definition_name = "dq-no-network-config"
    }]
  }
  expect_failure = true
}
