# Copyright IBM Corp. 2026

policytest {
  targets = ["firewall-rule-create-update-alert.policy.hcl"]
}

resource "azurerm_mssql_server" "fail_server_without_alert" {
  expect_failure = true
  attrs = {
    name                = "sqlsrv1"
    resource_group_name = "sql-rg"
    location            = "eastus"
    version             = "12.0"
    administrator_login = "sqladmin"
    minimum_tls_version = "1.2"
  }
}

resource "azurerm_mssql_firewall_rule" "fail_firewall_rule_without_alert" {
  expect_failure = true
  attrs = {
    name             = "allow-office"
    server_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/sql-rg/providers/Microsoft.Sql/servers/sqlsrv1"
    start_ip_address = "203.0.113.10"
    end_ip_address   = "203.0.113.20"
  }
}
