
variable "CreatedVmIPAddr" {
  type    = string
  default = "192.168.164.196"
}

variable "Name_Ethernet_Bridge_Interface" {
  type    = string
  default = "Intel(R) Ethernet Connection I217-LM"
}

variable "Name_TPlink_Bridge_Interface" {
  type    = string
  default = "TP-Link Wireless USB Adapter"
}

variable "PackerHostIPAddr" {
  type    = string
  default = "192.168.1.101"
}

variable "PackerHostIPAddrWifi" {
  type    = string
  default = "192.168.164.236"
}

variable "build_directory" {
  type    = string
  default = "pokusbox_library"
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "disk_size" {
  type    = string
  default = "65536"
}

variable "git_revision" {
  type    = string
  default = "__unknown_git_revision__"
}

variable "hostname" {
  type    = string
  default = "pokus-packer-test"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "name" {
  type    = string
  default = "debian-11.3"
}

variable "os_cpu_arch_reference" {
  type    = string
  default = "debian-11.3-amd64"
}

variable "preseed_path" {
  type    = string
  default = "debian/bullseye/amd64/preseed.cfg"
}

variable "ssh_name" {
  type    = string
  default = "pokus"
}

variable "ssh_pass" {
  type    = string
  default = "pokus"
}

locals {
  boot_command           = "<esc><wait>install <wait> preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_path} <wait>debian-installer=en_US.UTF-8 <wait>auto <wait>locale=en_US.UTF-8 <wait>kbd-chooser/method=us <wait>keyboard-configuration/xkb-keymap=us <wait>netcfg/get_hostname={{ .Name }} <wait>netcfg/get_domain=pokusup.com <wait>fb=false <wait>debconf/frontend=noninteractive <wait>console-setup/ask_detect=false <wait>console-keymaps-at/keymap=fr <wait>grub-installer/bootdev=default <wait><enter><wait>"
  boot_command_env_addon = "packer_fileserver_ip={{ .HTTPIP }} packer_fileserver_port={{ .HTTPPort }} hostname=${var.hostname} golang_version=1.18.3 hugo_version=0.100.2"
}

source "virtualbox-iso" "debian_hugo_64" {
  boot_command     = ["<esc><wait>install <wait>", "preseed/url=http://${var.PackerHostIPAddrWifi}:{{ .HTTPPort }}/${var.preseed_path} <wait>", "debian-installer=en_US.UTF-8 <wait>", "auto=true <wait>", "priority=critical  <wait>", "interface=enp0s3 <wait>", "netcfg/get_hostname={{ user `ssh_name` }} <wait>", "netcfg/get_domain=pokusup.com <wait>", "locale=en_US.UTF-8 <wait>", "kbd-chooser/method=us <wait>", "keyboard-configuration/xkb-keymap=fr <wait>", "fb=false <wait>", "debconf/frontend=noninteractive <wait>", "console-setup/ask_detect=false <wait>", "console-keymaps-at/keymap=fr <wait>", "grub-installer/bootdev=default ", "PACKER_AUTHORIZED_KEY=%3Cno+value%3E<enter>", "${local.boot_command_env_addon}", " <wait><enter><wait>"]
  boot_wait        = "5s"
  cpus             = "${var.cpus}"
  disk_size        = "${var.disk_size}"
  guest_os_type    = "Debian_64"
  http_directory   = "http_directory"
  http_port_max    = 9001
  http_port_min    = 9001
  iso_checksum     = "sha256:7892981e1da216e79fb3a1536ce5ebab157afdd20048fe458f2ae34fbc26c19b"
  iso_url          = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.3.0-amd64-netinst.iso"
  memory           = "${var.memory}"
  output_directory = "${var.build_directory}/packer-${var.os_cpu_arch_reference}-iso"
  shutdown_command = "echo ${var.ssh_pass} | sudo -S shutdown -P now"
  ssh_host         = "${var.CreatedVmIPAddr}"
  ssh_password     = "${var.ssh_pass}"
  ssh_port         = 22
  ssh_timeout      = "10000s"
  ssh_username     = "${var.ssh_name}"
  vboxmanage       = [["modifyvm", "{{ .Name }}", "--vram", "96"], ["modifyvm", "{{ .Name }}", "--nic1", "bridged"], ["modifyvm", "{{ .Name }}", "--bridgeadapter1", "${var.Name_TPlink_Bridge_Interface}"], ["modifyvm", "{{ .Name }}", "--nic2", "bridged"], ["modifyvm", "{{ .Name }}", "--bridgeadapter2", "${var.Name_Ethernet_Bridge_Interface}"]]
}

build {
  sources = ["source.virtualbox-iso.debian_hugo_64"]
}
packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.4"
      source = "github.com/hashicorp/virtualbox"
    }
  }
}