provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file)
}

resource "google_compute_instance" "jenkins" {
  name         = "jenkins"
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
      // Assigns external IP
    }
  }
}
output "instance_ip" {
  value = google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip
}
