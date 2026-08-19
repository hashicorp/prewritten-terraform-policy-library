# Copyright IBM Corp. 2026

policytest {
  targets = ["4-8-shielded-vm.policy.hcl"]
}

resource "google_compute_instance" "pass_required_controls_enabled" {
  attrs = {
    name         = "pass-required-controls-enabled"
    machine_type = "e2-micro"
    boot_disk = {
      initialize_params = {
        image = "debian-cloud/debian-12"
      }
    }
    network_interface = {
      network = "default"
    }
    shielded_instance_config = {
      enable_vtpm                 = true
      enable_integrity_monitoring = true
      enable_secure_boot          = false
    }
  }
}

resource "google_compute_instance" "fail_missing_shielded_config" {
  expect_failure = true
  attrs = {
    name         = "fail-missing-shielded-config"
    machine_type = "e2-micro"
    boot_disk = {
      initialize_params = {
        image = "debian-cloud/debian-12"
      }
    }
    network_interface = {
      network = "default"
    }
  }
}

resource "google_compute_instance" "fail_null_shielded_config" {
  expect_failure = true
  attrs = {
    name         = "fail-null-shielded-config"
    machine_type = "e2-micro"
    boot_disk = {
      initialize_params = {
        image = "debian-cloud/debian-12"
      }
    }
    network_interface = {
      network = "default"
    }
    shielded_instance_config = null
  }
}

resource "google_compute_instance" "fail_empty_shielded_config" {
  expect_failure = true
  attrs = {
    name         = "fail-empty-shielded-config"
    machine_type = "e2-micro"
    boot_disk = {
      initialize_params = {
        image = "debian-cloud/debian-12"
      }
    }
    network_interface = {
      network = "default"
    }
    shielded_instance_config = {}
  }
}

resource "google_compute_instance" "fail_vtpm_disabled" {
  expect_failure = true
  attrs = {
    name         = "fail-vtpm-disabled"
    machine_type = "e2-micro"
    boot_disk = {
      initialize_params = {
        image = "debian-cloud/debian-12"
      }
    }
    network_interface = {
      network = "default"
    }
    shielded_instance_config = {
      enable_vtpm                 = false
      enable_integrity_monitoring = true
    }
  }
}

resource "google_compute_instance" "fail_integrity_monitoring_disabled" {
  expect_failure = true
  attrs = {
    name         = "fail-integrity-monitoring-disabled"
    machine_type = "e2-micro"
    boot_disk = {
      initialize_params = {
        image = "debian-cloud/debian-12"
      }
    }
    network_interface = {
      network = "default"
    }
    shielded_instance_config = {
      enable_vtpm                 = true
      enable_integrity_monitoring = false
    }
  }
}
