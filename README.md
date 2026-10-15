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
