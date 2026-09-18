# Prewritten Terraform policy Library - Beta

A library of prewritten terraform policies for multiple cloud providers.

## Supported Providers

| Provider | Services covered | Policies |
| -------- | ----------- | -------- |
| AWS | 58 services | 348 |
| Azure | 3 services | 16 |
| GCP | 3 services | 17 |

Additional providers will be added in future releases.

## AWS — Foundational Security Best Practices (FSBP)

The AWS policies in this library implement controls from the [AWS Foundational Security Best Practices (FSBP) standard](https://docs.aws.amazon.com/securityhub/latest/userguide/fsbp-standard.html) as defined in AWS Security Hub CSPM. FSBP is a compilation of security best practices developed by AWS and industry professionals that detects when AWS accounts and resources deviate from security best practices.

## Azure — CIS Azure Foundations Benchmark

The Azure policies in this library implement a subset of controls from the [CIS Azure Foundations Benchmark](https://www.cisecurity.org/benchmark/azure). The CIS Azure Benchmark is a set of security configuration best practices for Microsoft Azure developed by the Center for Internet Security (CIS).

> **Note:** Only a subset of the CIS Azure Benchmark controls are currently implemented as policies in this library — not the full benchmark. Coverage will expand in future releases.

## GCP — CIS GCP Foundations Benchmark

The GCP policies in this library implement a subset of controls from the [CIS Google Cloud Platform Foundation Benchmark](https://www.cisecurity.org/benchmark/google_cloud_computing_platform). The CIS GCP Benchmark is a set of security configuration best practices for Google Cloud Platform developed by the Center for Internet Security (CIS).

> **Note:** Only a subset of the CIS GCP Benchmark controls are currently implemented as policies in this library — not the full benchmark. Coverage will expand in future releases.

## Repository structure

```
policies/
├── aws/
│   ├── acm/
│   ├── apigateway/
│   ├── ...                  (58 service folders)
│   └── workspaces/
├── azure/
│   ├── iam/
│   ├── network/
│   └── storage/
└── gcp/
    ├── iam/
    ├── network/
    └── compute/
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
