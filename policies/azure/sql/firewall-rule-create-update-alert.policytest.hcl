# Copyright IBM Corp. 2026

policytest {
  targets = ["firewall-rule-create-update-alert.policy.hcl"]
}

resource "azurerm_mssql_server" "pass_server_with_alert" {
  attrs = {
    name                = "sqlsrv1"
    resource_group_name = "sql-rg"
    location            = "eastus"
    version             = "12.0"
    administrator_login = "sqladmin"
    minimum_tls_version = "1.2"
  }
}

resource "azurerm_mssql_firewall_rule" "pass_firewall_rule_with_alert" {
  attrs = {
    name             = "allow-office"
    server_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/sql-rg/providers/Microsoft.Sql/servers/sqlsrv1"
    start_ip_address = "203.0.113.10"
    end_ip_address   = "203.0.113.20"
  }
}

resource "azurerm_monitor_activity_log_alert" "compliant_alert" {
  skip = true
  attrs = {
    name                = "sql-fw-rule-write-alert"
    location            = "global"
    resource_group_name = "monitoring-rg"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/write"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/monitoring-rg/providers/Microsoft.Insights/actionGroups/ag1"
    }]
  }
}

# Optional level, status and caller filters do not affect compliance.
resource "azurerm_monitor_activity_log_alert" "compliant_alert_with_filters" {
  skip = true
  attrs = {
    name                = "sql-fw-rule-write-alert-filtered"
    location            = "global"
    resource_group_name = "monitoring-rg"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/write"
      level          = "Verbose"
      status         = "Succeeded"
      caller         = "user@example.com"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/monitoring-rg/providers/Microsoft.Insights/actionGroups/ag1"
    }]
  }
}
