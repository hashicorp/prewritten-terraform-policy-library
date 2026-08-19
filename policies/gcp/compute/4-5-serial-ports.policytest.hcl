# Copyright IBM Corp. 2026

policytest {
  targets = ["4-5-serial-ports.policy.hcl"]
}

resource "google_compute_instance" "pass_metadata_omitted" {
  attrs = {
    name         = "metadata-omitted"
    machine_type = "e2-micro"
    zone         = "us-central1-a"
    boot_disk = [{
      initialize_params = [{ image = "debian-cloud/debian-12" }]
    }]
    network_interface = [{ network = "default" }]
  }
}

resource "google_compute_instance" "pass_serial_key_omitted" {
  attrs = {
    name              = "serial-key-omitted"
    machine_type      = "e2-micro"
    zone              = "us-central1-a"
    boot_disk         = [{ initialize_params = [{ image = "debian-cloud/debian-12" }] }]
    network_interface = [{ network = "default" }]
    metadata          = { environment = "test" }
  }
}

resource "google_compute_instance" "pass_serial_disabled_false" {
  attrs = {
    name              = "serial-disabled-false"
    machine_type      = "e2-micro"
    zone              = "us-central1-a"
    boot_disk         = [{ initialize_params = [{ image = "debian-cloud/debian-12" }] }]
    network_interface = [{ network = "default" }]
    metadata          = { "serial-port-enable" = "false" }
  }
}

resource "google_compute_instance" "pass_serial_disabled_zero" {
  attrs = {
    name              = "serial-disabled-zero"
    machine_type      = "e2-micro"
    zone              = "us-central1-a"
    boot_disk         = [{ initialize_params = [{ image = "debian-cloud/debian-12" }] }]
    network_interface = [{ network = "default" }]
    metadata          = { "serial-port-enable" = "0" }
  }
}

resource "google_compute_instance" "fail_serial_enabled_true" {
  expect_failure = true
  attrs = {
    name              = "serial-enabled-true"
    machine_type      = "e2-micro"
    zone              = "us-central1-a"
    boot_disk         = [{ initialize_params = [{ image = "debian-cloud/debian-12" }] }]
    network_interface = [{ network = "default" }]
    metadata          = { "serial-port-enable" = "true" }
  }
}

resource "google_compute_instance" "fail_serial_value_empty" {
  expect_failure = true
  attrs = {
    name              = "serial-value-empty"
    machine_type      = "e2-micro"
    zone              = "us-central1-a"
    boot_disk         = [{ initialize_params = [{ image = "debian-cloud/debian-12" }] }]
    network_interface = [{ network = "default" }]
    metadata          = { "serial-port-enable" = "" }
  }
}
