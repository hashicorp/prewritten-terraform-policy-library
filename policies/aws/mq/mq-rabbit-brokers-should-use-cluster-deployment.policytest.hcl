# Copyright IBM Corp. 2026

policytest {
  targets = ["mq-rabbit-brokers-should-use-cluster-deployment.policy.hcl"]
}

resource "aws_mq_broker" "rabbit_cluster_pass" {
  attrs = {
    broker_name        = "b1"
    engine_type        = "RabbitMQ"
    engine_version     = "3.13"
    host_instance_type = "mq.m5.large"
    deployment_mode    = "CLUSTER_MULTI_AZ"
  }
}

resource "aws_mq_broker" "rabbit_single_fail" {
  expect_failure = true
  attrs = {
    broker_name        = "b2"
    engine_type        = "RabbitMQ"
    engine_version     = "3.13"
    host_instance_type = "mq.m5.large"
    deployment_mode    = "SINGLE_INSTANCE"
  }
}

resource "aws_mq_broker" "rabbit_unset_fail" {
  expect_failure = true
  attrs = {
    broker_name        = "b3"
    engine_type        = "RabbitMQ"
    engine_version     = "3.13"
    host_instance_type = "mq.m5.large"
  }
}

resource "aws_mq_broker" "rabbit_null_fail" {
  expect_failure = true
  attrs = {
    broker_name        = "b4"
    engine_type        = "RabbitMQ"
    engine_version     = "3.13"
    host_instance_type = "mq.m5.large"
    deployment_mode    = null
  }
}

resource "aws_mq_broker" "rabbit_active_standby_fail" {
  expect_failure = true
  attrs = {
    broker_name        = "b5"
    engine_type        = "RabbitMQ"
    engine_version     = "3.13"
    host_instance_type = "mq.m5.large"
    deployment_mode    = "ACTIVE_STANDBY_MULTI_AZ"
  }
}

resource "aws_mq_broker" "activemq_single_pass" {
  attrs = {
    broker_name        = "b6"
    engine_type        = "ActiveMQ"
    engine_version     = "5.17.6"
    host_instance_type = "mq.m5.large"
    deployment_mode    = "SINGLE_INSTANCE"
  }
}

resource "aws_mq_broker" "activemq_unset_pass" {
  attrs = {
    broker_name        = "b7"
    engine_type        = "ActiveMQ"
    engine_version     = "5.17.6"
    host_instance_type = "mq.m5.large"
  }
}

resource "aws_mq_broker" "activemq_active_standby_pass" {
  attrs = {
    broker_name        = "b8"
    engine_type        = "ActiveMQ"
    engine_version     = "5.17.6"
    host_instance_type = "mq.m5.large"
    deployment_mode    = "ACTIVE_STANDBY_MULTI_AZ"
  }
}

# engine_type lowercasing: "rabbitmq" (all-lowercase) is matched by core::lower() filter
resource "aws_mq_broker" "rabbit_cluster_pass_lowercase" {
  attrs = {
    broker_name        = "b9"
    engine_type        = "rabbitmq"
    engine_version     = "3.13"
    host_instance_type = "mq.m5.large"
    deployment_mode    = "CLUSTER_MULTI_AZ"
  }
}

resource "aws_mq_broker" "rabbit_single_fail_lowercase" {
  expect_failure = true
  attrs = {
    broker_name        = "b10"
    engine_type        = "rabbitmq"
    engine_version     = "3.13"
    host_instance_type = "mq.m5.large"
    deployment_mode    = "SINGLE_INSTANCE"
  }
}

# engine_type lowercasing: "RABBITMQ" (all-uppercase) is matched by core::lower() filter
resource "aws_mq_broker" "rabbit_cluster_pass_uppercase" {
  attrs = {
    broker_name        = "b11"
    engine_type        = "RABBITMQ"
    engine_version     = "3.13"
    host_instance_type = "mq.m5.large"
    deployment_mode    = "CLUSTER_MULTI_AZ"
  }
}

resource "aws_mq_broker" "rabbit_single_fail_uppercase" {
  expect_failure = true
  attrs = {
    broker_name        = "b12"
    engine_type        = "RABBITMQ"
    engine_version     = "3.13"
    host_instance_type = "mq.m5.large"
    deployment_mode    = "SINGLE_INSTANCE"
  }
}

