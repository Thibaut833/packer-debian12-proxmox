source "proxmox-iso" "debian-kickstart" {
  boot_command = [
    "<esc><wait>",
    "install <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>",
    "debian-installer=fr_FR.UTF-8 <wait>",
    "auto <wait>",
    "locale=fr_FR.UTF-8 <wait>",
    "kbd-chooser/method=fr <wait>",
    "keyboard-configuration/xkb-keymap=fr <wait>",
    "netcfg/get_ipaddress=${var.tpl_address} <wait>",
    "netcfg/get_netmask=${var.tpl_netmask} <wait>",
    "netcfg/get_gateway=${var.tpl_gtw} <wait>",
    "netcfg/get_nameservers=${var.tpl_dns} <wait>",
    "netcfg/disable_autoconfig=true <wait>",
    "netcfg/get_hostname=template <wait>",
    "netcfg/get_domain=${var.tpl_domain} <wait>",
    "fb=false <wait>",
    "debconf/frontend=noninteractive <wait>",
    "console-setup/ask_detect=false <wait>",
    "console-keymaps-at/keymap=fr <wait>",
    "grub-installer/bootdev=/dev/sda <wait>",
    "<enter><wait>"
  ]
    boot_wait = "10s"

    disks {
      disk_size         = "20G"
      storage_pool      = "data2"
      type              = "scsi"
      storage_pool_type = "lvm"
      format            = "raw"
    }
    disks {
      disk_size         = "50G"
      storage_pool      = "data2"
      type              = "scsi"
      storage_pool_type = "lvm"
      format            = "raw"
    }

    http_directory           = "http_dir"
    insecure_skip_tls_verify = true
    iso_file                 = "local:iso/debian-12.0.0-amd64-netinst.iso"

    network_adapters {
      bridge = "vmbr0"
      model  = "virtio"
      firewall = false
    }

    node                 = "prox"
    password             = "${var.password}"
    username             = "${var.username}"
    proxmox_url          = "${var.urlprox}"
    ssh_password         = "${var.sshpass}"
    ssh_username         = "${var.sshuser}"
    ssh_timeout          = "15m"
    vm_name              = "debian12"
    sockets              = 1
    cores                = 2
    memory               = 4096
    pool                 = "VM"
    template_description = "Debian 12 generated on ${timestamp()}"
    template_name        = "debian12"
    unmount_iso          = true
    cloud_init           = true
    cloud_init_storage_pool = "data2"
  }

  build {
    sources = ["source.proxmox-iso.debian-kickstart"]

    provisioner "ansible" {
      playbook_file = "./playbooks/template.yml"
      extra_arguments = ["--vault-password-file=passvault.txt", "--extra-vars", "ansible_ssh_pass=${var.sshpass}", "--extra-vars", "ansible_become_pass=${var.sshpass}"]
      keep_inventory_file = true
      use_proxy = false
      ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    }
  }
