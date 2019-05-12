provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata_item" "default" {
  key   = "ssh-keys"
  value = "${var.user}:${file(var.public_key_path)}"
}

resource "google_compute_instance" "crawler-host" {
  name         = "${var.name}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  tags         = ["crawler"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  metadata {
    ssh-keys = "${var.user}:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "${var.user}"
    agent       = true
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    script = "../install_docker_script.sh"
  }
}

