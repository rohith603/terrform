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
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -e
    
    # Update system and install prerequisites
    sudo apt update && sudo apt install -y curl gnupg openjdk-17-jdk
    
    # Add Jenkins repository
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee "/usr/share/keyrings/jenkins-keyring.asc" > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee "/etc/apt/sources.list.d/jenkins.list" > /dev/null
    
    # Install Jenkins
    sudo apt update && sudo apt install -y jenkins
    
    # Enable and start Jenkins service
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
  EOT
}

output "instance_ip" {
  value = google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip
}
