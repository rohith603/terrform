terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file)
}

resource "google_compute_instance" "vm" {
  count        = 2  # Create 2 VMs
  name         = "vm-${count.index + 1}"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  tags = ["web", "ssh"]
}

output "vm_public_ips" {
  value = google_compute_instance.vm[*].network_interface[0].access_config[0].nat_ip
}
