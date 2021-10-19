resource "google_compute_instance" "controller" {
  name         = "controller"
  machine_type = "e2-standard-2"

  tags = ["controller"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }

  can_ip_forward = true

  network_interface {
    network    = "vpc-network"
    network_ip = "10.240.0.10"
    subnetwork = var.subnet_name
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }
}

resource "google_compute_instance" "node1" {
  name         = "node1"
  machine_type = "e2-standard-2"

  tags = ["node"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }

  can_ip_forward = true

  network_interface {
    network    = "vpc-network"
    network_ip = "10.240.0.20"
    subnetwork = var.subnet_name
  }

  metadata = {
    foo = "bar"
  }

  

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }
}

