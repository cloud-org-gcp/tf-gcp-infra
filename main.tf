provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}

resource "google_compute_subnetwork" "subnet_webapp" {
  name          = var.webapp_subnet_name
  ip_cidr_range = var.webapp_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "subnet_db" {
  name          = var.db_subnet_name
  ip_cidr_range = var.db_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_route" "default_route" {
  name       = "default-route"
  network    = google_compute_network.vpc_network.name
  dest_range = "0.0.0.0/0"
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "deny_ssh" {
  name    = "deny-ssh"
  network = google_compute_network.vpc_network.name

  deny {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "webapp_instance" {
  name         = "webapp-instance"
  machine_type = "e2-medium"  # You can choose any suitable machine type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/${var.project}/global/images/${var.custom_image_name}"  # Use the full self-link if necessary
      type  = "pd-balanced"
      size  = 100
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet_webapp.name

    access_config {
      # This block is needed to assign an external IP to the instance
    }
  }
}