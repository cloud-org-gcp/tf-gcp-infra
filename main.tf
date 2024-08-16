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

# Enable Private Services Access for Cloud SQL
resource "google_compute_global_address" "private_ip_range" {
  name          = "private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.vpc_network.name
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.name
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}

# Create a CloudSQL instance
resource "google_sql_database_instance" "cloudsql_instance" {
  name             = "webapp-sql-instance"
  database_version = "POSTGRES_15"
  region           = var.region
  deletion_protection = false
  depends_on       = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = "db-f1-micro"
    disk_size         = 100
    disk_type         = "PD_SSD"
    availability_type = "REGIONAL"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.self_link
    }
  }
}

# Create a database within the CloudSQL instance
resource "google_sql_database" "webapp_database" {
  name     = var.db_name
  instance = google_sql_database_instance.cloudsql_instance.name
}

# Create a database user and password
resource "google_sql_user" "webapp_user" {
  name     = var.db_user
  instance = google_sql_database_instance.cloudsql_instance.name
  password = var.db_password
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
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]  # Allow from any IP

  # No target specified, so this rule applies to all instances
}

# Allow the webapp to access the CloudSQL instance
resource "google_compute_firewall" "allow_sql_access" {
  name    = "allow-sql-access"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = [google_compute_subnetwork.subnet_webapp.ip_cidr_range]
}

# Create the Compute Engine instance
resource "google_compute_instance" "webapp_instance" {
  name         = "webapp-instance"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/${var.project}/global/images/${var.custom_image_name}"
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
  metadata = {
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
    DB_HOST     = google_sql_database_instance.cloudsql_instance.private_ip_address
    DB_NAME     = var.db_name
  }
  metadata_startup_script = file("${path.module}/startup.sh")
}