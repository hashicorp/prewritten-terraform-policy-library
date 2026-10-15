# Copyright IBM Corp. 2026

policytest {
  targets = ["asset-inventory-enabled.policy.hcl"]
}

resource "google_project_service" "fail_other_service_without_project_resource" {
  expect_failure = true
  attrs = {
    service = "compute.googleapis.com"
  }
}
