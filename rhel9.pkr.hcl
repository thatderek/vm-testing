packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

variable "headless" { 
  type        = bool
  default     = true
  description = "Determines whether to run VirutalBox in headless mode. Useful for debugging."
}

variable "cpus" { 
  type        = number
  default     = 2
  description = "The number of CPUs that should be made available to the VirutalBox vboxmanage command."
}

variable "memory" { 
  type        = number
  default     = 4096
  description = "The amount of memory that should be made available to the VirutalBox vboxmanage command."
}

source "virtualbox-iso" "rocky_linux_9" {
  guest_os_type    = "RedHat_64"
  iso_url          = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.4-x86_64-boot.iso"
  iso_checksum     = "sha256:c7e95e3dba88a1f68fff8b7d4e66adf6f76ac4fba2e246a83c46ab79574c78a8"
  
  ssh_username     = "root"
  ssh_password     = "packer"
  ssh_timeout      = "20m"

  shutdown_command = "shutdown -P now"

  boot_wait = "20s"
  headless  = var.headless

  boot_command = [
    "<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rhel9.ks.cfg<enter><wait>"
  ]

  http_directory = "http"
  vm_name        = "rocky-linux-9"
  cpus           = var.cpus
  memory         = var.memory
  disk_size      = 10000

  format = "ova"
}

build {
  sources = ["source.virtualbox-iso.rocky_linux_9"]

  provisioner "shell" {
    inline = [
      "dnf update -y",
      "dnf install -y ansible-core podman"
    ]
  }

  provisioner "file" { 
    source      = "../"
    destination = "/tmp/"
  }
}
