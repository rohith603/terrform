provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file)
}

resource "google_compute_instance" "ansible_tower" {
  name         = "ansible-tower"
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

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y docker.io docker-compose python3-pip
    sudo systemctl start docker && sudo systemctl enable docker
    sudo usermod -aG docker $USER

    # Install Ansible & dependencies
    sudo apt install -y ansible git

    # Clone the AWX repository
    git clone --depth 1 https://github.com/ansible/awx.git /opt/awx

    # Install AWX via Ansible
    cd /opt/awx/installer
    ansible-playbook -i inventory install.yml -e "ansible_python_interpreter=/usr/bin/python3"

  EOT
}

output "instance_ip" {
  value = google_compute_instance.ansible_tower.network_interface[0].access_config[0].nat_ip
}
