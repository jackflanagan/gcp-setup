resource "google_compute_instance" "grafter" {
  name         = "grafter"
  machine_type = "e2-standard-2"

  tags = ["grafter"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }

  can_ip_forward = true

  network_interface {
    network    = "vpc-network"
    network_ip = "10.240.0.11"
    subnetwork = var.subnet_name
    access_config {
      nat_ip = var.external_ip
    }
  }

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }
}