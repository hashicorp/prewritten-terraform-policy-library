# Copyright IBM Corp. 2026

policytest {
  targets = ["firewall-rule-delete-alert.policy.hcl"]
}

resource "azurerm_resource_group" "pass_no_sql_server_in_plan" {
  attrs = {
    name     = "unrelated-rg"
    location = "eastus"
  }
}
