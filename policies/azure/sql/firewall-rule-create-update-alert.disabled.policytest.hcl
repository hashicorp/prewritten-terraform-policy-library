# Copyright IBM Corp. 2026

policytest {
  targets = ["firewall-rule-create-update-alert.policy.hcl"]
}

resource "azurerm_mssql_server" "fail_alert_disabled" {
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

resource "azurerm_monitor_activity_log_alert" "disabled_alert" {
  skip = true
  attrs = {
    name                = "disabled_alert"
    location            = "global"
    resource_group_name = "monitoring-rg"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = false
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/write"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/monitoring-rg/providers/Microsoft.Insights/actionGroups/ag1"
    }]
  }
}
