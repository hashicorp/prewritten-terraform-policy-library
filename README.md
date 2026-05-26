# Prewritten Terraform Policy Library

A library of prewritten policies for multiple cloud providers.

## Supported Providers

| Provider | Policy sets | Policies |
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

Per-policy documentation lives under `docs/policies/aws/`. Each file includes:

- A description of the FSBP control
- The AWS provider and Security Hub category
- Expected `tfpolicy test` output

## Contributing

1. Add the policy under `policies/<provider>/<service>/`.
2. Add a companion `.policytest.hcl` covering at least one pass and one fail case.
3. Add a doc file under `docs/policies/<provider>/` following the existing format.
