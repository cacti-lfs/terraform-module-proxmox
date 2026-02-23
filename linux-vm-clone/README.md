# Proxmox VM Clone BGP Module
![Terraform](https://img.shields.io/badge/terraform-%23623CE4.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Proxmox](https://img.shields.io/badge/Proxmox-E57000?style=for-the-badge&logo=proxmox&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

## Requirements
|    Name   | Version |
| --------- | ------- |
| terraform | >=1.5.0 |

## Providers
|     Name    | Version  |
| ----------- | -------- |
| bgp proxmox | >=0.90.0 |

## Variables

| Variable | Défaut | Type | Description | Requis |
| :--- | :--- | :--- | :--- | :--- |
| `**Non**de_name` | | String | **Non**m du nœud Proxmox où la VM sera créée | **Oui** |
| `vm_id` | | Number | ID de la VM à cloner | **Oui** |
| `vm_name` | | String | **Non**m de la VM clonée | **Oui** |
| `vm_description` | `""` | String | Description de la VM clonée | **Non** |
| `vm_tags` | `[]` | List(String) | Tags à associer à la VM clonée | **Non** |
| `source_vm_id` | | Number | ID de la VM source à cloner | **Oui** |
| `full_clone` | `false` | Boolean | Indique si le clone doit être complet (true) ou lié (false) | **Non** |
| `vm_bios` | `seabios` | String | Type de BIOS à utiliser pour la VM clonée (ex: ovmf, seabios) | **Non** |
| `vm_machine` | `q35` | String | Type de machine virtuelle à utiliser pour la VM clonée (ex: q35, i440fx) | **Non** |
| `vm_os_type` | `l26` | String | Type de système d'exploitation à utiliser pour la VM clonée | **Non** |
| `vm_agent_enabled` | `true` | Boolean | Activer l'agent QEMU pour la VM clonée (true/false) | **Non** |
| `vm_tablet_device` | `false` | Boolean | Ajouter un périphérique de tablette à la VM clonée (true/false) | **Non** |
| `vm_cpu_cores` | `2` | Number | **Non**mbre de cœurs CPU à allouer à la VM clonée | **Non** |
| `vm_cpu_type` | `host` | String | Type de CPU à utiliser pour la VM clonée (ex: host, kvm64) | **Non** |
| `vm_memory_dedicated` | `1G` | String | Quantité de mémoire dédiée à allouer à la VM clonée (ex: 4G) | **Non** |
| `vm_memory_floating` | `0G` | String | Quantité de mémoire flottante à allouer à la VM clonée (ex: 2G) | **Non** |
| `vm_vga_type` | `std` | String | Type de carte VGA à utiliser pour la VM clonée (ex: std, qxl) | **Non** |
| `vm_vga_memory` | `16M` | String | Quantité de mémoire vidéo à allouer pour la VM clonée (ex: 16M) | **Non** |
| `vnic_model` | | String | Modèle de la carte réseau virtuelle à utiliser pour la VM clonée | **Oui** |
| `vnic_bridge` | | String | Pont réseau à utiliser pour la carte réseau virtuelle de la VM clonée | **Oui** |
| `vlan_tag` | `0` | Number | ID de VLAN à utiliser pour la carte réseau virtuelle de la VM clonée | **Non** |

### Variables des disques (dynamic)

| Variable | Défaut | Type | Description | Requis |
| :--- | :--- | :--- | :--- | :--- |
| `disks` | `[]` | List(Object) | Liste des disques à attacher (storage_id, size, type, interface) | **Non** |
| `disk_storage_id` | `""` | String | ID du stockage pour les disques de la VM clonée | **Non** |
| `disk_interface` | `virtio` | String | Interface du disque de la VM clonée (ex: virtio, scsi) | **Non** |
| `disk_file_format` | `qcow2` | String | Format du fichier de disque de la VM clonée (ex: qcow2, raw) | **Non** |
| `disk_iothread` | `false` | Boolean | Indique si le disque doit utiliser un iothread dédié | **Non** |
| `disk_cache` | `**Non**ne` | String | Mode de cache du disque de la VM clonée | **Non** |
| `disk_ssd` | `false` | Boolean | Indique si le disque doit être traité comme un SSD | **Non** |
| `disk_discard` | `false` | Boolean | Indique si le disque doit supporter TRIM/discard | **Non** |

### Variables Cloud-init

| Variable | Défaut | Type | Description | Requis |
| :--- | :--- | :--- | :--- | :--- |
| `ci_datastore_id` | `""` | String | ID du datastore pour les données d'initialisation | **Non** |
| `ci_user_data_file_id` | `""` | String | ID du fichier de données utilisateur d'initialisation | **Non** |
| `user_account_username`| `""` | String | **Non**m d'utilisateur pour le compte utilisateur de la VM | **Non** |
| `user_account_ssh_public_keys` | `[]` | List(String) | Liste des clés SSH publiques à ajouter au compte | **Non** |
| `ipv4_address` | `""` | String | Adresse IPv4 à configurer pour la VM clonée | **Non** |
| `ipv4_gateway` | `""` | String | Passerelle IPv4 à configurer pour la VM clonée | **Non** |
| `dns_domain` | `""` | String | Domaine DNS à configurer pour la VM clonée | **Non** |
| `dns_servers` | `[]` | List(String) | Liste des serveurs DNS à configurer pour la VM clonée | **Non** |

## Usage

Voici un exemple simple pour déployer une VM Debian avec Cloud-Init :

```hcl
module "my_vm" {
  source = "./modules/proxmox-vm" # ou ton lien GitHub

  node_name    = "pve-01"
  vm_id        = 100
  vm_name      = "web-server"
  source_vm_id = 9000 # Ton ID de template

  vnic_model  = "virtio"
  vnic_bridge = "vmbr0"

  user_account_username        = "admin"
  user_account_ssh_public_keys = ["ssh-ed25519 AAAAC3Nza..."]
  ipv4_address                 = "192.168.1.50/24"
  ipv4_gateway                 = "192.168.1.1"
}
```

## Features
* **Multi-OS Ready** : Supporte Linux (Cloud-init) et Windows.
* **Dynamic Disks** : Ajoutez autant de disques que nécessaire via une simple liste d'objets.
* **Auto-EFI** : Génère automatiquement un disque EFI si le BIOS est configuré sur `ovmf`.
* **Lifecycle Management** : Ignore les changements sur l'utilisateur Cloud-init après le premier déploiement pour éviter les remplacements inutiles.

## License
Ce projet est sous licence **MIT**. Vous êtes libre de l'utiliser, de le modifier et de le distribuer, tant que vous conservez l'avis de copyright original. Voir le fichier [LICENSE](../LICENSE) pour plus de détails.