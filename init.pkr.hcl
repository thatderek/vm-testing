packer {
    required_plugins {
        virtualbox = {
          version = "~> 1"
          source  = "github.com/hashicorp/virtualbox"
        }
    }
}

source "virtualbox-iso" "rocky-9-minimal" {
  guest_os_type = "RedHat9_64"
  iso_url = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.4-x86_64-minimal.iso"
  iso_checksum = "md5:ee3ac97fdffab58652421941599902012179c37535aece76824673105169c4a2"
  ssh_username = "packer"
  ssh_password = "packer"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
}

build {
  sources = ["sources.virtualbox-iso.rocky-9-minimal"]

  provisioner "shell" {
    inline = ["echo foo"]
  }
}

