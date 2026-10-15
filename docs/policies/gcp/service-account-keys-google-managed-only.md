# Ensure That There Are Only GCP-Managed Service Account Keys for Each Service Account

| Provider | Category |
| -------- | -------- |
| Google Cloud Platform | Identity and access management |

## Description

This control checks whether Terraform creates a user-managed service account key through `google_service_account_key`. GCP-managed keys are created and rotated by Google and cannot be downloaded, while user-managed keys are downloadable and must be stored, distributed, revoked, and rotated by their owners. Exposing a user-managed key can allow others to access resources as the service account.

Every `google_service_account_key` resource is treated as a violation, with no exceptions or allow-list. The result does not vary by key algorithm or whether a public key is uploaded. GCP-managed keys are not represented by this Terraform resource, and a key cannot be created for a GCP-managed service account. This check only sees resources in the Terraform plan; keys created outside Terraform and the `iam.disableServiceAccountKeyCreation` organization policy are not evaluated.

This rule is covered by the [service-account-keys-google-managed-only](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/gcp/iam/service-account-keys-google-managed-only.policy.hcl) policy.

## Policy Results

```bash
trace:
   # service-account-keys-google-managed-only.policytest.hcl...
   running
   # resource.google_service_account.pass_sa_without_keys...
   running
   # resource.google_service_account.pass_sa_without_keys...
   pass
   # resource.google_service_account_key.fail_user_managed_key...
   running
   # resource.google_service_account_key.fail_user_managed_key...
   pass
   # resource.google_service_account_key.fail_key_with_algorithm...
   running
   # resource.google_service_account_key.fail_key_with_algorithm...
   pass
   # resource.google_service_account_key.fail_uploaded_public_key...
   running
   # resource.google_service_account_key.fail_uploaded_public_key...
   pass
   # resource.google_service_account_key.fail_bare_email...
   running
   # resource.google_service_account_key.fail_bare_email...
   pass
   # service-account-keys-google-managed-only.policytest.hcl...
   pass
```

---
