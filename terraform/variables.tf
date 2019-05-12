variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable zone {
  description = "Instance zone"
  default     = "europe-west1-c"
}

variable name {
  description = "Instance name"
  default     = "crawler"
}

variable user {
  description = "Username"
  default     = "appuser"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable machine_type {
  description = "Machine type"
  default     = "n1-standard-1"
}

variable disk_image {
  description = "Disk image"
  default     = "ubuntu-1604-lts"
}

variable private_key_path {
  description = "Private key path"
}


