# Policy : MQ.2 - ActiveMQ brokers should stream audit logs to CloudWatch

policy {}

input "mq-cloudwatch-audit-log-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_mq_broker" "activemq_audit_logs_enabled" {
    enforcement_level = input.mq-cloudwatch-audit-log-enabled-enforcement-level
    filter = core::try(attrs.engine_type, "") == "ActiveMQ"

    locals {
        audit_enabled_raw = core::try(attrs.logs[0].audit, false)
        audit_enabled = local.audit_enabled_raw == true || local.audit_enabled_raw == "true"
    }

    enforce {
        condition = local.audit_enabled == true
        error_message = "ActiveMQ broker does not have audit logging enabled. Set 'logs.audit = true' to stream audit logs to CloudWatch Logs. This is required for security monitoring and compliance (NIST.800-53.r5 AU-2, AU-3, AU-12, SI-4; PCI DSS v4.0.1/10.3.3). Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/mq-controls.html#mq-2 for more details."
    }
}
