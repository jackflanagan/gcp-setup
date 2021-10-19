resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet1" {
  name          = "subnetwork"
  ip_cidr_range = "10.240.0.0/24"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "internal_comms" {
  name    = "internalfirewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
      }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["10.240.0.0/24", "10.200.0.0/16"]
}

resource "google_compute_firewall" "external_comms" {
  name    = "externalfirewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "6443", "80", "443", "8080"]
  }


  allow {
    protocol = "icmp"
  }

  source_ranges = var.public_ip
}

resource "google_compute_address" "ip_address" {
  name = "public-address"
}

resource "google_compute_router" "router" {
  name    = "my-router"
  network = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}