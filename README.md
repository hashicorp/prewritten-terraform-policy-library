# Prewritten Terraform policy Library

A library of prewritten terraform policies for multiple cloud providers.

## Supported Providers

| Provider | Services covered | Policies |
| -------- | ----------- | -------- |
| AWS | 60 services | 396 |
| Azure | 8 services | 82 |
| GCP | 8 services | 68 |

Additional providers will be added in future releases.

## AWS — Foundational Security Best Practices (FSBP)

The AWS policies in this library implement controls from the [AWS Foundational Security Best Practices (FSBP) standard](https://docs.aws.amazon.com/securityhub/latest/userguide/fsbp-standard.html) as defined in AWS Security Hub CSPM. FSBP is a compilation of security best practices developed by AWS and industry professionals that detects when AWS accounts and resources deviate from security best practices.

## AWS — CIS AWS Foundations Benchmark

A subset of the AWS policies also implement controls from the [CIS AWS Foundations Benchmark](https://docs.aws.amazon.com/securityhub/latest/userguide/cis-aws-foundations-benchmark.html) as defined in AWS Security Hub CSPM (v1.2.0, v1.4.0, v3.0.0 and v5.0.0).

## AWS — NIST SP 800-53 Rev. 5

The AWS policies cover controls from the [NIST SP 800-53 Rev. 5 standard](https://docs.aws.amazon.com/securityhub/latest/userguide/standards-reference-nist-800-53.html) in AWS Security Hub CSPM, including NIST controls that are not part of FSBP or CIS.

## AWS — PCI DSS

The AWS policies cover controls from the [PCI DSS standard](https://docs.aws.amazon.com/securityhub/latest/userguide/pci-standard.html) (v3.2.1 and v4.0.1) in AWS Security Hub CSPM.

## AWS — AI Security Best Practices

The AWS policies cover controls from the [AI Security Best Practices standard](https://docs.aws.amazon.com/securityhub/latest/userguide/standards-ai-security.html) in AWS Security Hub CSPM for Amazon Bedrock, Amazon Bedrock AgentCore and Amazon SageMaker AI.

> **Note:** A single AWS policy can satisfy controls in more than one standard. Not every control in these standards is implemented; some controls cannot be evaluated from a Terraform plan.

## Azure — CIS Azure Foundations Benchmark

The Azure policies in this library implement a subset of controls from the [CIS Azure Foundations Benchmark](https://www.cisecurity.org/benchmark/azure) v6.0.0. The CIS Azure Benchmark is a set of security configuration best practices for Microsoft Azure developed by the Center for Internet Security (CIS).

> **Note:** Only a subset of the CIS Azure Benchmark controls are currently implemented as policies in this library — not the full benchmark. Coverage will expand in future releases.

## GCP — CIS GCP Foundations Benchmark

The GCP policies in this library implement a subset of controls from the [CIS Google Cloud Platform Foundation Benchmark](https://www.cisecurity.org/benchmark/google_cloud_computing_platform) v5.0.0. The CIS GCP Benchmark is a set of security configuration best practices for Google Cloud Platform developed by the Center for Internet Security (CIS).

> **Note:** Only a subset of the CIS GCP Benchmark controls are currently implemented as policies in this library — not the full benchmark. Coverage will expand in future releases.

## Policies added in 1.0.0

One row per policy and standard; a policy that maps to more than one standard appears once per standard. AWS references link to the AWS Security Hub control; Azure and GCP references link to the vendor documentation cited by the CIS recommendation.

| Provider | Standard | Policy | Control | Reference |
|---|---|---|---|---|
| AWS | AI Security Best Practices | `bedrock-data-source-encryption-enabled` | Bedrock.1 | [Bedrock.1](https://docs.aws.amazon.com/securityhub/latest/userguide/bedrock-controls.html#bedrock-1) |
| AWS | AI Security Best Practices | `bedrockagentcore-codeinterpreter-networkmode-check` | BedrockAgentCore.7 | [BedrockAgentCore.7](https://docs.aws.amazon.com/securityhub/latest/userguide/bedrockagentcore-controls.html#bedrockagentcore-7) |
| AWS | NIST SP 800-53 Rev. 5 | `bedrockagentcore-gateway-encrypted-cmk` | BedrockAgentCore.4 | [BedrockAgentCore.4](https://docs.aws.amazon.com/securityhub/latest/userguide/bedrockagentcore-controls.html#bedrockagentcore-4) |
| AWS | AI Security Best Practices | `bedrockagentcore-gateway-encrypted-cmk` | BedrockAgentCore.4 | [BedrockAgentCore.4](https://docs.aws.amazon.com/securityhub/latest/userguide/bedrockagentcore-controls.html#bedrockagentcore-4) |
| AWS | NIST SP 800-53 Rev. 5 | `bedrockagentcore-memory-encrypted-cmk` | BedrockAgentCore.3 | [BedrockAgentCore.3](https://docs.aws.amazon.com/securityhub/latest/userguide/bedrockagentcore-controls.html#bedrockagentcore-3) |
| AWS | AI Security Best Practices | `bedrockagentcore-memory-encrypted-cmk` | BedrockAgentCore.3 | [BedrockAgentCore.3](https://docs.aws.amazon.com/securityhub/latest/userguide/bedrockagentcore-controls.html#bedrockagentcore-3) |
| AWS | NIST SP 800-53 Rev. 5 | `cloudtrail-lake-event-data-stores-should-be-encrypted-with-customer-managed-aws-kms-keys` | CloudTrail.10 | [CloudTrail.10](https://docs.aws.amazon.com/securityhub/latest/userguide/cloudtrail-controls.html#cloudtrail-10) |
| AWS | NIST SP 800-53 Rev. 5 | `cloudwatch-alarm-actions-should-be-enabled` | CloudWatch.17 | [CloudWatch.17](https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-17) |
| AWS | NIST SP 800-53 Rev. 5 | `cloudwatch-alarms-should-have-specified-actions-configured` | CloudWatch.15 | [CloudWatch.15](https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-15) |
| AWS | NIST SP 800-53 Rev. 5 | `cloudwatch-log-groups-should-be-retained-for-a-specified-time-period` | CloudWatch.16 | [CloudWatch.16](https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-16) |
| AWS | NIST SP 800-53 Rev. 5 | `ebs-volumes-should-be-in-a-backup-plan` | EC2.28 | [EC2.28](https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-28) |
| AWS | NIST SP 800-53 Rev. 5 | `ecr-repositories-should-be-encrypted-with-customer-managed-aws-kms-keys` | ECR.5 | [ECR.5](https://docs.aws.amazon.com/securityhub/latest/userguide/ecr-controls.html#ecr-5) |
| AWS | NIST SP 800-53 Rev. 5 | `ecs-task-definitions-should-not-use-host-network-mode` | ECS.17 | [ECS.17](https://docs.aws.amazon.com/securityhub/latest/userguide/ecs-controls.html#ecs-17) |
| AWS | NIST SP 800-53 Rev. 5 | `application-load-balancers-should-be-associated-with-an-aws-waf-web-acl` | ELB.16 | [ELB.16](https://docs.aws.amazon.com/securityhub/latest/userguide/elb-controls.html#elb-16) |
| AWS | NIST SP 800-53 Rev. 5 | `eventbridge-global-endpoints-should-have-event-replication-enabled` | EventBridge.4 | [EventBridge.4](https://docs.aws.amazon.com/securityhub/latest/userguide/eventbridge-controls.html#eventbridge-4) |
| AWS | NIST SP 800-53 Rev. 5 | `lambda-function-xray-enabled` | Lambda.7 | [Lambda.7](https://docs.aws.amazon.com/securityhub/latest/userguide/lambda-controls.html#lambda-7) |
| AWS | NIST SP 800-53 Rev. 5 | `lambda-functions-should-be-in-a-vpc` | Lambda.3 | [Lambda.3](https://docs.aws.amazon.com/securityhub/latest/userguide/lambda-controls.html#lambda-3) |
| AWS | PCI DSS | `lambda-functions-should-be-in-a-vpc` | Lambda.3 | [Lambda.3](https://docs.aws.amazon.com/securityhub/latest/userguide/lambda-controls.html#lambda-3) |
| AWS | NIST SP 800-53 Rev. 5 | `mq-active-deployment-mode` | MQ.5 | [MQ.5](https://docs.aws.amazon.com/securityhub/latest/userguide/mq-controls.html#mq-5) |
| AWS | NIST SP 800-53 Rev. 5 | `mq-rabbit-brokers-should-use-cluster-deployment` | MQ.6 | [MQ.6](https://docs.aws.amazon.com/securityhub/latest/userguide/mq-controls.html#mq-6) |
| AWS | NIST SP 800-53 Rev. 5 | `msk-clusters-should-have-enhanced-monitoring-enabled` | MSK.2 | [MSK.2](https://docs.aws.amazon.com/securityhub/latest/userguide/msk-controls.html#msk-2) |
| AWS | NIST SP 800-53 Rev. 5 | `neptune-cluster-should-be-deployed-in-multi-az` | Neptune.9 | [Neptune.9](https://docs.aws.amazon.com/securityhub/latest/userguide/neptune-controls.html#neptune-9) |
| AWS | NIST SP 800-53 Rev. 5 | `network-firewall-should-be-deployed-across-multiple-azs` | NetworkFirewall.1 | [NetworkFirewall.1](https://docs.aws.amazon.com/securityhub/latest/userguide/networkfirewall-controls.html#networkfirewall-1) |
| AWS | NIST SP 800-53 Rev. 5 | `opensearch-primary-node-count-should-be-atleast-3` | Opensearch.11 | [Opensearch.11](https://docs.aws.amazon.com/securityhub/latest/userguide/opensearch-controls.html#opensearch-11) |
| AWS | NIST SP 800-53 Rev. 5 | `rds-resources-protected-by-backup-plan` | RDS.26 | [RDS.26](https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-26) |
| AWS | NIST SP 800-53 Rev. 5 | `redshift-serverless-namespace-should-be-encrypted-with-cmk` | RedshiftServerless.4 | [RedshiftServerless.4](https://docs.aws.amazon.com/securityhub/latest/userguide/redshiftserverless-controls.html#redshiftserverless-4) |
| AWS | NIST SP 800-53 Rev. 5 | `s3-bucket-should-be-encrypted-at-rest` | S3.17 | [S3.17](https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-17) |
| AWS | PCI DSS | `s3-bucket-should-be-encrypted-at-rest` | S3.17 | [S3.17](https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-17) |
| AWS | NIST SP 800-53 Rev. 5 | `s3-bucket-should-have-event-notifications-enabled` | S3.11 | [S3.11](https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-11) |
| AWS | NIST SP 800-53 Rev. 5 | `s3-bucket-should-have-object-lock-enabled` | S3.15 | [S3.15](https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-15) |
| AWS | PCI DSS | `s3-bucket-should-have-object-lock-enabled` | S3.15 | [S3.15](https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-15) |
| AWS | NIST SP 800-53 Rev. 5 | `s3-bucket-should-have-versioning-enabled` | S3.14 | [S3.14](https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-14) |
| AWS | NIST SP 800-53 Rev. 5 | `s3-bucket-should-use-cross-region-replication` | S3.7 | [S3.7](https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-7) |
| AWS | PCI DSS | `s3-bucket-should-use-cross-region-replication` | S3.7 | [S3.7](https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-7) |
| AWS | NIST SP 800-53 Rev. 5 | `s3-bucket-with-versioning-should-have-lifecycle-configurations` | S3.10 | [S3.10](https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-10) |
| AWS | NIST SP 800-53 Rev. 5 | `sagemaker-featuregroup-online-store-encryption` | SageMaker.18 | [SageMaker.18](https://docs.aws.amazon.com/securityhub/latest/userguide/sagemaker-controls.html#sagemaker-18) |
| AWS | AI Security Best Practices | `sagemaker-featuregroup-online-store-encryption` | SageMaker.18 | [SageMaker.18](https://docs.aws.amazon.com/securityhub/latest/userguide/sagemaker-controls.html#sagemaker-18) |
| AWS | AI Security Best Practices | `sagemaker-monitoring-schedule-traffic-encryption` | SageMaker.22 | [SageMaker.22](https://docs.aws.amazon.com/securityhub/latest/userguide/sagemaker-controls.html#sagemaker-22) |
| AWS | AI Security Best Practices | `sagemaker-notebook-instance-storage-vol-kms-encrypted` | SageMaker.21 | [SageMaker.21](https://docs.aws.amazon.com/securityhub/latest/userguide/sagemaker-controls.html#sagemaker-21) |
| AWS | NIST SP 800-53 Rev. 5 | `sns-topic-should-be-encrypted-at-rest` | SNS.1 | [SNS.1](https://docs.aws.amazon.com/securityhub/latest/userguide/sns-controls.html#sns-1) |
| AWS | NIST SP 800-53 Rev. 5 | `wafv2-webacl-should-have-logging-enabled` | WAF.11 | [WAF.11](https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-11) |
| AWS | PCI DSS | `wafv2-webacl-should-have-logging-enabled` | WAF.11 | [WAF.11](https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-11) |
| Azure | CIS Azure Foundations v6.0.0 | `databricks-diagnostic-logging-enabled` | 2.1.7 | [Link](https://learn.microsoft.com/en-us/azure/databricks/admin/account-settings/audit-log-delivery) |
| Azure | CIS Azure Foundations v6.0.0 | `databricks-no-public-ip-enabled` | 2.1.9 | [Link](https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/secure-cluster-connectivity) |
| Azure | CIS Azure Foundations v6.0.0 | `databricks-private-endpoints-used` | 2.1.11 | [Link](https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/private-link) |
| Azure | CIS Azure Foundations v6.0.0 | `databricks-public-network-access-disabled` | 2.1.10 | [Link](https://learn.microsoft.com/en-us/azure/databricks/security/network/front-end/front-end-private-connect) |
| Azure | CIS Azure Foundations v6.0.0 | `databricks-subnet-nsg-configured` | 2.1.2 | [Link](https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/vnet-inject#network-security-group-rules) |
| Azure | CIS Azure Foundations v6.0.0 | `databricks-vnet-injection` | 2.1.1 | [Link](https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/vnet-inject) |
| Azure | CIS Azure Foundations v6.0.0 | `mfa-enabled-all-users` | 5.1.3 | [Link](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mfa-howitworks) |
| Azure | CIS Azure Foundations v6.0.0 | `no-custom-subscription-admin-roles` | 5.4 | [Link](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/add-change-subscription-administrator) |
| Azure | CIS Azure Foundations v6.0.0 | `user-access-administrator-restricted` | 5.3.3 | [Link](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles) |
| Azure | CIS Azure Foundations v6.0.0 | `automatic-key-rotation-enabled` | 8.3.9 | [Link](https://learn.microsoft.com/en-us/azure/key-vault/keys/how-to-configure-key-rotation) |
| Azure | CIS Azure Foundations v6.0.0 | `certificate-validity-12-months` | 8.3.11 | [Link](https://learn.microsoft.com/en-us/azure/key-vault/certificates/about-certificates) |
| Azure | CIS Azure Foundations v6.0.0 | `key-expiration-access-policy` | 8.3.2 | [Link](https://learn.microsoft.com/en-us/azure/key-vault/general/basic-concepts) |
| Azure | CIS Azure Foundations v6.0.0 | `key-expiration-rbac` | 8.3.1 | [Link](https://learn.microsoft.com/en-us/azure/key-vault/general/basic-concepts) |
| Azure | CIS Azure Foundations v6.0.0 | `keyvault-logging-enabled` | 6.1.1.4 | [Link](https://learn.microsoft.com/en-us/azure/key-vault/general/howto-logging) |
| Azure | CIS Azure Foundations v6.0.0 | `private-endpoints-used` | 8.3.8 | [Link](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `public-network-access-disabled` | 8.3.7 | [Link](https://learn.microsoft.com/en-us/azure/key-vault/general/network-security) |
| Azure | CIS Azure Foundations v6.0.0 | `purge-protection-enabled` | 8.3.5 | [Link](https://learn.microsoft.com/en-us/azure/key-vault/general/key-vault-recovery) |
| Azure | CIS Azure Foundations v6.0.0 | `rbac-enabled` | 8.3.6 | [Link](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-migration#vault-access-policy-to-azure-rbac-migration-steps) |
| Azure | CIS Azure Foundations v6.0.0 | `secret-expiration-access-policy` | 8.3.4 | [Link](https://learn.microsoft.com/en-us/azure/key-vault/general/basic-concepts) |
| Azure | CIS Azure Foundations v6.0.0 | `secret-expiration-rbac` | 8.3.3 | [Link](https://learn.microsoft.com/en-us/azure/key-vault/general/basic-concepts) |
| Azure | CIS Azure Foundations v6.0.0 | `application-insights-configured` | 6.1.3.1 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `create-policy-assignment-alert` | 6.1.2.1 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule) |
| Azure | CIS Azure Foundations v6.0.0 | `create-update-nsg-alert` | 6.1.2.3 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule) |
| Azure | CIS Azure Foundations v6.0.0 | `create-update-public-ip-alert` | 6.1.2.9 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule) |
| Azure | CIS Azure Foundations v6.0.0 | `create-update-security-solution-alert` | 6.1.2.5 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule) |
| Azure | CIS Azure Foundations v6.0.0 | `delete-nsg-alert` | 6.1.2.4 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule) |
| Azure | CIS Azure Foundations v6.0.0 | `delete-policy-assignment-alert` | 6.1.2.2 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule) |
| Azure | CIS Azure Foundations v6.0.0 | `delete-public-ip-alert` | 6.1.2.10 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule) |
| Azure | CIS Azure Foundations v6.0.0 | `delete-security-solution-alert` | 6.1.2.6 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule) |
| Azure | CIS Azure Foundations v6.0.0 | `security-contact-email-configured` | 8.1.13 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/configure-email-notifications) |
| Azure | CIS Azure Foundations v6.0.0 | `service-health-alert` | 6.1.2.11 | [Link](https://learn.microsoft.com/en-us/azure/service-health/overview) |
| Azure | CIS Azure Foundations v6.0.0 | `subscription-diagnostic-setting-categories` | 6.1.1.2 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings) |
| Azure | CIS Azure Foundations v6.0.0 | `subscription-diagnostic-setting-exists` | 6.1.1.1 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/data-sources) |
| Azure | CIS Azure Foundations v6.0.0 | `application-gateway-http2-enabled` | 7.13 | [Link](https://learn.microsoft.com/en-us/azure/application-gateway/features#websocket-and-http2-traffic) |
| Azure | CIS Azure Foundations v6.0.0 | `application-gateway-tls12` | 7.12 | [Link](https://learn.microsoft.com/en-us/azure/application-gateway/application-gateway-ssl-policy-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `application-gateway-waf-enabled` | 7.10 | [Link](https://learn.microsoft.com/en-us/azure/application-gateway/features) |
| Azure | CIS Azure Foundations v6.0.0 | `network-watcher-enabled` | 7.6 | [Link](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `nsg-flow-log-retention` | 7.5 | [Link](https://learn.microsoft.com/en-us/azure/network-watcher/nsg-flow-logs-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `ssh-internet-restrict` | 7.2 | [Link](https://learn.microsoft.com/en-us/azure/security/fundamentals/network-best-practices#disable-rdpssh-access-to-virtual-machines) |
| Azure | CIS Azure Foundations v6.0.0 | `subnet-nsg-associated` | 7.11 | [Link](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `vnet-ddos-protection-enabled` | 8.5 | [Link](https://learn.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `vnet-flow-log-retention` | 7.8 | [Link](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-manage) |
| Azure | CIS Azure Foundations v6.0.0 | `vpn-entra-auth-only` | 7.9 | [Link](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways) |
| Azure | CIS Azure Foundations v6.0.0 | `waf-bot-protection-enabled` | 7.15 | [Link](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/bot-protection-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `waf-request-body-inspection-enabled` | 7.14 | [Link](https://learn.microsoft.com/en-gb/azure/web-application-firewall/ag/application-gateway-waf-request-size-limits#request-body-inspection) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-apis-on` | 8.1.2.1 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-apis-introduction) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-app-services-on` | 8.1.6.1 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/alerts-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-containers-on` | 8.1.4.1 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-containers-introduction) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-cosmosdb-on` | 8.1.7.1 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/connect-azure-subscription) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-cspm-on` | 8.1.1.1 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-cloud-security-posture-management) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-keyvault-on` | 8.1.8.1 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/alerts-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-open-source-relational-databases-on` | 8.1.7.2 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/alerts-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-resource-manager-on` | 8.1.9.1 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/connect-azure-subscription) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-servers-on` | 8.1.3.1 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-servers-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-sql-databases-on` | 8.1.7.3 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/alerts-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-sql-servers-on-machines-on` | 8.1.7.4 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-sql-usage) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-storage-on` | 8.1.5.1 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/alerts-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `defender-vm-os-updates` | 8.1.10 | [Link](https://learn.microsoft.com/en-us/security/benchmark/azure/mcsb-posture-vulnerability-management#pv-6-rapidly-and-automatically-remediate-vulnerabilities) |
| Azure | CIS Azure Foundations v6.0.0 | `endpoint-protection-status-on` | 8.1.3.3 | [Link](https://learn.microsoft.com/en-us/azure/defender-for-cloud/integration-defender-for-endpoint) |
| Azure | CIS Azure Foundations v6.0.0 | `firewall-rule-create-update-alert` | 6.1.2.7 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule) |
| Azure | CIS Azure Foundations v6.0.0 | `firewall-rule-delete-alert` | 6.1.2.8 | [Link](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-activity-log-alert-rule) |
| Azure | CIS Azure Foundations v6.0.0 | `container-soft-delete` | 9.2.2 | [Link](https://learn.microsoft.com/en-us/azure/storage/blobs/soft-delete-container-overview) |
| Azure | CIS Azure Foundations v6.0.0 | `smb-protocol-version-311` | 9.1.2 | [Link](https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-files#recommendations-for-smb-file-shares) |
| Azure | CIS Azure Foundations v6.0.0 | `storage-default-network-deny` | 9.3.2.3 | [Link](https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security) |
| Azure | CIS Azure Foundations v6.0.0 | `storage-geo-redundant` | 9.3.11 | [Link](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy) |
| Azure | CIS Azure Foundations v6.0.0 | `storage-private-endpoint` | 9.3.2.1 | [Link](https://learn.microsoft.com/en-us/azure/storage/common/storage-private-endpoints) |
| GCP | CIS GCP Foundation v5.0.0 | `bq-dataset-cmek` | 7.3 | [Link](https://cloud.google.com/bigquery/docs/customer-managed-encryption) |
| GCP | CIS GCP Foundation v5.0.0 | `bq-no-public-datasets` | 7.1 | [Link](https://cloud.google.com/bigquery/docs/dataset-access-controls) |
| GCP | CIS GCP Foundation v5.0.0 | `bq-table-cmek` | 7.2 | [Link](https://cloud.google.com/bigquery/docs/customer-managed-encryption) |
| GCP | CIS GCP Foundation v5.0.0 | `os-login` | 4.4 | [Link](https://cloud.google.com/compute/docs/instances/managing-instance-access) |
| GCP | CIS GCP Foundation v5.0.0 | `dataproc-cmek` | 8.1 | [Link](https://cloud.google.com/docs/security/encryption/default-encryption) |
| GCP | CIS GCP Foundation v5.0.0 | `api-key-restrictions` | 1.15 | [Link](https://cloud.google.com/docs/authentication/api-keys) |
| GCP | CIS GCP Foundation v5.0.0 | `essential-contacts` | 1.17 | [Link](https://cloud.google.com/resource-manager/docs/managing-notification-contacts) |
| GCP | CIS GCP Foundation v5.0.0 | `kms-key-rotation` | 1.11 | [Link](https://cloud.google.com/kms/docs/key-rotation#frequency_of_key_rotation) |
| GCP | CIS GCP Foundation v5.0.0 | `kms-not-public` | 1.10 | [Link](https://cloud.google.com/kms/docs/object-hierarchy#key_resource_id) |
| GCP | CIS GCP Foundation v5.0.0 | `no-api-keys` | 1.13 | [Link](https://cloud.google.com/docs/authentication/api-keys) |
| GCP | CIS GCP Foundation v5.0.0 | `service-account-keys` | 1.5 | [Link](https://cloud.google.com/iam/docs/understanding-service-accounts#managing_service_account_keys) |
| GCP | CIS GCP Foundation v5.0.0 | `asset-inventory` | 2.14 | [Link](https://cloud.google.com/asset-inventory/docs) |
| GCP | CIS GCP Foundation v5.0.0 | `audit-config-change-alert` | 2.6 | [Link](https://cloud.google.com/logging/docs/logs-based-metrics/) |
| GCP | CIS GCP Foundation v5.0.0 | `audit-logging` | 2.1 | [Link](https://cloud.google.com/logging/docs/audit/) |
| GCP | CIS GCP Foundation v5.0.0 | `custom-role-change-alert` | 2.7 | [Link](https://cloud.google.com/logging/docs/logs-based-metrics/) |
| GCP | CIS GCP Foundation v5.0.0 | `dns-logging` | 2.13 | [Link](https://cloud.google.com/dns/docs/monitoring) |
| GCP | CIS GCP Foundation v5.0.0 | `firewall-rule-change-alert` | 2.8 | [Link](https://cloud.google.com/logging/docs/logs-based-metrics/) |
| GCP | CIS GCP Foundation v5.0.0 | `load-balancer-logging` | 2.17 | [Link](https://cloud.google.com/load-balancing/) |
| GCP | CIS GCP Foundation v5.0.0 | `log-export-bucket-lock` | 2.4 | [Link](https://cloud.google.com/storage/docs/bucket-lock) |
| GCP | CIS GCP Foundation v5.0.0 | `log-sinks` | 2.3 | [Link](https://cloud.google.com/logging/quotas) |
| GCP | CIS GCP Foundation v5.0.0 | `network-change-alert` | 2.10 | [Link](https://cloud.google.com/logging/docs/logs-based-metrics/) |
| GCP | CIS GCP Foundation v5.0.0 | `project-ownership-change-alert` | 2.5 | [Link](https://cloud.google.com/logging/docs/logs-based-metrics/) |
| GCP | CIS GCP Foundation v5.0.0 | `route-change-alert` | 2.9 | [Link](https://cloud.google.com/logging/docs/logs-based-metrics/) |
| GCP | CIS GCP Foundation v5.0.0 | `sql-config-change-alert` | 2.12 | [Link](https://cloud.google.com/logging/docs/logs-based-metrics/) |
| GCP | CIS GCP Foundation v5.0.0 | `storage-iam-change-alert` | 2.11 | [Link](https://cloud.google.com/logging/docs/logs-based-metrics/) |
| GCP | CIS GCP Foundation v5.0.0 | `dnssec-enabled` | 3.3 | [Link](https://cloudplatform.googleblog.com/2017/11/DNSSEC-now-available-in-Cloud-DNS.html) |
| GCP | CIS GCP Foundation v5.0.0 | `dnssec-no-rsasha1-ksk` | 3.4 | [Link](https://cloud.google.com/dns/dnssec-advanced#advanced_signing_options) |
| GCP | CIS GCP Foundation v5.0.0 | `dnssec-no-rsasha1-zsk` | 3.5 | [Link](https://cloud.google.com/dns/dnssec-advanced#advanced_signing_options) |
| GCP | CIS GCP Foundation v5.0.0 | `contained-db-auth-off` | 6.3.7 | [Link](https://cloud.google.com/sql/docs/sqlserver/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `cross-db-chaining-off` | 6.3.2 | [Link](https://cloud.google.com/sql/docs/sqlserver/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `external-scripts-off` | 6.3.1 | [Link](https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/external-scripts-enabled-server-configuration-option?view=sql-server-ver15) |
| GCP | CIS GCP Foundation v5.0.0 | `local-infile-off` | 6.1.3 | [Link](https://cloud.google.com/sql/docs/mysql/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `log-connections` | 6.2.2 | [Link](https://cloud.google.com/sql/docs/postgres/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `log-disconnections` | 6.2.3 | [Link](https://cloud.google.com/sql/docs/postgres/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `log-error-verbosity` | 6.2.1 | [Link](https://cloud.google.com/sql/docs/postgres/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `log-min-duration` | 6.2.7 | [Link](https://cloud.google.com/sql/docs/postgres/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `log-min-error-statement` | 6.2.6 | [Link](https://cloud.google.com/sql/docs/postgres/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `log-min-messages` | 6.2.5 | [Link](https://cloud.google.com/sql/docs/postgres/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `log-statement` | 6.2.4 | [Link](https://cloud.google.com/sql/docs/postgres/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `pgaudit-enabled` | 6.2.8 | [Link](https://cloud.google.com/sql/docs/postgres/flags#list-flags-postgres) |
| GCP | CIS GCP Foundation v5.0.0 | `remote-access-off` | 6.3.5 | [Link](https://cloud.google.com/sql/docs/sqlserver/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `skip-show-database` | 6.1.2 | [Link](https://cloud.google.com/sql/docs/mysql/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `sql-backups` | 6.8 | [Link](https://cloud.google.com/sql/docs/mysql/backup-recovery/backups) |
| GCP | CIS GCP Foundation v5.0.0 | `sql-no-open-networks` | 6.5 | [Link](https://cloud.google.com/sql/docs/mysql/configure-ip) |
| GCP | CIS GCP Foundation v5.0.0 | `sql-no-public-ip` | 6.7 | [Link](https://cloud.google.com/sql/docs/mysql/configure-private-ip) |
| GCP | CIS GCP Foundation v5.0.0 | `sql-require-ssl` | 6.4 | [Link](https://cloud.google.com/sql/docs/postgres/configure-ssl-instance/) |
| GCP | CIS GCP Foundation v5.0.0 | `trace-flag-3625` | 6.3.6 | [Link](https://cloud.google.com/sql/docs/sqlserver/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `user-connections` | 6.3.3 | [Link](https://cloud.google.com/sql/docs/sqlserver/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `user-options` | 6.3.4 | [Link](https://cloud.google.com/sql/docs/sqlserver/flags) |
| GCP | CIS GCP Foundation v5.0.0 | `no-public-buckets` | 5.1 | [Link](https://cloud.google.com/storage/docs/access-control/iam-reference) |
| GCP | CIS GCP Foundation v5.0.0 | `uniform-bucket-access` | 5.2 | [Link](https://cloud.google.com/storage/docs/uniform-bucket-level-access) |

## Repository structure

```
policies/
├── aws/
│   ├── acm/
│   ├── apigateway/
│   ├── ...                  (60 service folders)
│   └── workspaces/
├── azure/
│   ├── databricks/
│   ├── iam/
│   ├── keyvault/
│   ├── monitor/
│   ├── network/
│   ├── security-center/
│   ├── sql/
│   └── storage/
└── gcp/
    ├── bigquery/
    ├── compute/
    ├── dataproc/
    ├── iam/
    ├── logging/
    ├── network/
    ├── sql/
    └── storage/
docs/
└── policies/
    ├── aws/                 (one .md per policy — description, category, test output)
    ├── azure/               (one .md per policy — description, category, test output)
    └── gcp/                 (one .md per policy — description, category, test output)
```

## Prerequisites

### Install tfpolicy

Download and install the `tfpolicy` binary by following the instructions at [Terraform policy Install](https://developer.hashicorp.com/terraform/policy/install).

### Verify the installation

```bash
tfpolicy version
```

## Usage

### Validate a policy set

```bash
tfpolicy validate policies/aws/s3
tfpolicy validate policies/azure/storage
tfpolicy validate policies/gcp/iam
```

### Run tests for a policy set

```bash
tfpolicy test policies/aws/s3
tfpolicy test policies/azure/storage
tfpolicy test policies/gcp/iam
```

## Documentation

Per-policy documentation lives under `docs/policies/`. Each file includes:

- A description of the control
- The provider and the policy control category
- Expected `tfpolicy test` output
