# Prewritten Terraform policy Library

A library of prewritten terraform policies for multiple cloud providers.

## Supported Providers

| Provider | Services covered | Policies |
| -------- | ----------- | -------- |
| AWS | 60 services | 396 |
| Azure | 8 services | 82 |
| GCP | 8 services | 68 |

Additional providers will be added in future releases.

## Supported Standards

| Provider | Standard | Policies included | Reference |
| -------- | -------- | ----------------- | --------- |
| AWS | AWS Foundational Security Best Practices (FSBP) | 340 | [AWS Security Hub: FSBP](https://docs.aws.amazon.com/securityhub/latest/userguide/fsbp-standard.html) |
| AWS | CIS AWS Foundations Benchmark (v1.2.0, v1.4.0, v3.0.0, v5.0.0) | 44 | [AWS Security Hub: CIS AWS Foundations Benchmark](https://docs.aws.amazon.com/securityhub/latest/userguide/cis-aws-foundations-benchmark.html) |
| AWS | NIST SP 800-53 Rev. 5 | 277 | [AWS Security Hub: NIST SP 800-53 Rev. 5](https://docs.aws.amazon.com/securityhub/latest/userguide/standards-reference-nist-800-53.html) |
| AWS | PCI DSS (v3.2.1, v4.0.1) | 137 | [AWS Security Hub: PCI DSS](https://docs.aws.amazon.com/securityhub/latest/userguide/pci-standard.html) |
| AWS | AI Security Best Practices | 21 | [AWS Security Hub: AI Security Best Practices](https://docs.aws.amazon.com/securityhub/latest/userguide/standards-ai-security.html) |
| Azure | CIS Microsoft Azure Foundations Benchmark v6.0.0 | 82 | [CIS Azure Foundations Benchmark](https://www.cisecurity.org/benchmark/azure) |
| GCP | CIS Google Cloud Platform Foundation Benchmark v5.0.0 | 68 | [CIS Google Cloud Platform Foundation Benchmark](https://www.cisecurity.org/benchmark/google_cloud_computing_platform) |

> **Note:** A single AWS policy can implement controls from more than one standard, so the AWS rows add up to more than the 396 AWS policies. Only a subset of each standard's controls is implemented; some controls cannot be evaluated from a Terraform plan. Coverage will expand in future releases.

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
