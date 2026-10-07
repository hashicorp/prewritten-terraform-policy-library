# Copyright IBM Corp. 2026

policytest {
  targets = ["firewall-rule-delete-alert.policy.hcl"]
}


resource "azurerm_mssql_server" "fail_alert_wrong_operation" {
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

resource "azurerm_monitor_activity_log_alert" "wrong_operation_alert" {
  skip = true
  attrs = {
    name                = "wrong_operation_alert"
    location            = "global"
    resource_group_name = "monitoring-rg"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/write"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/monitoring-rg/providers/Microsoft.Insights/actionGroups/ag1"
    }]
  }
}
