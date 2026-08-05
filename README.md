# Prewritten Terraform Policy Library

A library of prewritten policies for multiple cloud providers.

## Supported Providers

| Provider | Services covered | Policies |
| -------- | ----------- | -------- |
| AWS | 58 services | 348 |

Additional providers will be added in future releases.

## AWS — Foundational Security Best Practices (FSBP)

The AWS policies in this library implement controls from the [AWS Foundational Security Best Practices (FSBP) standard](https://docs.aws.amazon.com/securityhub/latest/userguide/fsbp-standard.html) as defined in AWS Security Hub CSPM. FSBP is a compilation of security best practices developed by AWS and industry professionals that detects when AWS accounts and resources deviate from security best practices.

## Repository structure

```
policies/
└── aws/
    ├── acm/
    ├── apigateway/
    ├── ...                  (58 service folders)
    └── workspaces/
docs/
└── policies/
    └── aws/                 (one .md per policy — description, category, test output)
```

## Prerequisites

### Install tfpolicy

Download and install the `tfpolicy` binary by following the instructions at [Terraform Policy Install](https://developer.hashicorp.com/terraform/policy/install).

### Verify the installation

```bash
tfpolicy version
```

## Usage

### Validate a policy set

```bash
tfpolicy validate policies/aws/s3
```

### Run tests for a policy set

```bash
tfpolicy test policies/aws/s3
```

## Documentation

Per-policy documentation lives under `docs/policies/`. Each file includes:

- A description of the control
- The provider and the policy control category
- Expected `tfpolicy test` output
