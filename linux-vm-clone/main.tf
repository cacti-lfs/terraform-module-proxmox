terraform {
    required_version = ">=1.5.0"
  required_providers {
    proxmox = {
      version = ">=0.90.0"
      source  = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_vm" "linux_vm" {
  node_name     = var.node_name
  vm_id         = var.vm_id
  name          = var.vm_name
  description   = var.vm_description
  tags          = var.vm_tags
  bios          = var.vm_bios
  machine       = var.vm_machine
  tablet_device = var.vm_tablet_device

  operating_system {
    type = var.vm_os_type
  }

  agent {
    enabled = var.vm_agent_enabled
  }

  clone {
    node_name    = var.node_name
    source_vm_id = var.source_vm_id
    full_clone   = var.full_clone
  }

  cpu {
    cores = var.vm_cpu_cores
    type  = var.vm_cpu_type
    numa = var.vm_cpu_numa
  }

  memory {
    dedicated = var.vm_memory_dedicated
    floating  = var.vm_memory_floating
  }

  dynamic "numa" {
    for_each = (var.numa == true ? [1] : [])
    content {
        device = var.numa_device
        cpus = var.numa_cpus
        memory = var.numa_memory
        hostnodes = var.numa_hostnodes
        policy = var.numa_policy
    }    
  }

  vga {
    type = var.vm_vga_type
    momory = var.vm_vga_memory
  }

  dynamic "efi_fisk" {
    for_each = (var.bios == "ovmf" ? [1] : [])
    content {
        datastore_id = var.efi_disk_storage_id
        file_format = var.efi_disk_format
        type = var.efi_disk_type
        pre_enrolled_keys = var.efi_disk_pre_enrolled_keys
    }
  }

  network_device {
    model = var.vnic_model
    bridge = var.vnic_bridge
    vlan_id = var.vlan_tag
  }

  dynamic "disk" {
    for_each = var.disks
    content {
        datastore_id =disk.value.disk_storage_id
        interface = disk.value.disk_interface
        size = disk.value.disk_size
        file_format = disk.value.disk_file_format
        iothread = disk.value.disk_iothread
        cache = disk.value.disk_cache
        ssd = disk.value.disk_ssd
        discard = disk.value.disk_discard
    }
  }

  initialization {
    datastore_id = var.ci_datastore_id
    meta_data_file_id = var.ci_meta_data_file_id
    network_data_file_id = var.ci_network_data_file_id
    user_data_file_id = var.ci_user_data_file_id
    vendor_data_file_id = var.ci_vendor_data_file_id
  }

  user_account {
    username = var.user_account_username
    ssh_public_keys = var.user_account_ssh_public_keys
  }

  dns {
    domain = var.dns_domain
    servers = ( var.dns_servers != null ? [var.dns_servers] : [])
  }

  ip_configuration {
    ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
    }
  }

  lifecycle {
    ignore_changes = [initialization["user_account"],]
  }
}