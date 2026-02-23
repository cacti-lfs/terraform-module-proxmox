# Variable manquante pour cloud-init network data
variable "ci_network_data_file_id" {
    description = "ID du fichier network-data cloud-init pour la VM clonée"
    type        = string
    default     = ""
}
# variables.tf
# ==================================================================
# IDENTITE ET EMPLACEMENT DE LA VM
# ==================================================================
variable "node_name" {
    description = "Nom du nœud Proxmox où la VM sera créée"
    type        = string
}

variable "vm_id" {
   description = "ID de la VM à cloner"
    type        = number
}

variable "vm_name" {
    description = "Nom de la VM clonée"
    type        = string
}

variable "vm_description" {
    description = "Description de la VM clonée"
    type        = string
    default     = ""
}

variable "vm_tags" {
    description = "Tags à associer à la VM clonée"
    type        = list(string)
    default     = []
}

# ==================================================================
# SYSTEME ET BIOS
# ==================================================================
variable "vm_bios" {
    description = "Type de BIOS à utiliser pour la VM clonée (ex: ovmf, seabios)"
    type        = string
    default     = "seabios"
}

variable "vm_machine" {
    description = "Type de machine virtuelle à utiliser pour la VM clonée (ex: q35, i440fx)"
    type        = string
    default     = "q35"
}

variable "vm_tablet_device" {
    description = "Ajouter un périphérique de tablette à la VM clonée (true/false)"
    type        = bool
    default     = false
}
variable "vm_os_type" {
    description = "Type de système d'exploitation à utiliser pour la VM clonée (ex: l26, win10)"
    type        = string
    default     = "l26"
}

variable "vm_agent_enabled" {
    description = "Activer l'agent QEMU pour la VM clonée (true/false)"
    type        = bool
    default     = true
}

# ==================================================================
# CONFIGURATION DU CLONE (SOURCE)
# ==================================================================
variable "source_vm_id" {
    description = "ID de la VM source à cloner"
    type        = number
}

variable "full_clone" {
    description = "Indique si le clone doit être complet (true) ou lié (false)"
    type        = bool
    default     = false
}

# ==================================================================
# RESOURCES CPU ET MEMOIRE
# ==================================================================

variable "vm_cpu_cores" {
    description = "Nombre de cœurs CPU à allouer à la VM clonée"
    type        = number
    default     = 2
}

variable "vm_cpu_type" {
    description = "Type de CPU à utiliser pour la VM clonée (ex: host, kvm64)"
    type        = string
    default     = "host"
}

variable "vm_memory_dedicated" {
    description = "Quantité de mémoire dédiée à allouer à la VM clonée (ex: 4G)"
    type        = number
    default     = 1024
}

variable "vm_memory_floating" {
    description = "Quantité de mémoire flottante à allouer à la VM clonée (ex: 2G)"
    type        = number
    default     = 0
}

# --- TOPOLOGIE NUMA (AVANCE) ---
variable "vm_cpu_numa" {
    description = "Activer la topologie NUMA pour la VM clonée (true/false)"
    type        = bool
    default     = false
}

variable "numa" {
	description = "Activer NUMA (true/false)"
	type        = bool
	default     = false
}

variable "numa_device" {
    description = "Type de périphérique NUMA à utiliser pour la VM clonée (ex: memory, cpu)"
    type        = string
    default     = "memory"
}

variable "numa_cpus" {
    description = "Nombre de CPU à allouer pour le périphérique NUMA de la VM clonée"
    type        = number
    default     = 0
}

variable "numa_memory" {
    description = "Quantité de mémoire à allouer pour le périphérique NUMA de la VM clonée (ex: 4G)"
    type        = number
    default     = 0
}

variable "numa_hostnodes" {
    description = "Nœuds hôtes à utiliser pour le périphérique NUMA de la VM clonée (ex: 0,1)"
    type        = string
    default     = ""
}

variable "numa_policy" {
    description = "Politique NUMA à utiliser pour la VM clonée (ex: preferred, strict, interleave)"
    type        = string
    default     = "preferred"
}

# ==================================================================
# AFFICHAGE (VGA)
# ==================================================================
variable "vm_vga_type" {
    description = "Type de carte VGA à utiliser pour la VM clonée (ex: std, qxl)"
    type        = string
    default     = "std"
}

variable "vm_vga_memory" {
    description = "Quantité de mémoire vidéo à allouer pour la VM clonée (ex: 16M)"
    type        = number
    default     = 16
}

# ==================================================================
# STOCKAGE ET DISQUES
# ==================================================================
# --- DISQUE EFI (POUR BOOT UEFI) ---
variable "bios" {
	description = "Type de BIOS (ex: ovmf, seabios)"
	type        = string
	default     = "seabios"
}

variable "efi_disk_storage_id" {
    description = "ID du stockage pour le disque EFI de la VM clonée"
    type        = string
    default     = ""
}

variable "efi_disk_format" {
    description = "Format du disque EFI de la VM clonée (ex: qcow2, raw)"
    type        = string
    default     = "qcow2"
}

variable "efi_disk_type" {
    description = "Type de disque EFI de la VM clonée (ex: disk, cdrom)"
    type        = string
    default     = "disk"
}

variable "efi_disk_pre_enrolled_keys" {
    description = "Indique si les clés pré-enregistrées doivent être utilisées pour le disque EFI de la VM clonée (true/false)"
    type        = bool
    default     = false
}

# --- DISQUES DE DONNÉES ---
variable "disks" {
	description = "Liste des disques à attacher à la VM"
	type = list(object({
		disk_storage_id = string
		disk_size       = number
		disk_type       = string
		disk_interface  = string
        disk_file_format = optional(string, "qcow2")
        disk_iothread    = optional(bool, false)
        disk_cache       = optional(string, "none")
        disk_ssd         = optional(bool, false)
        disk_discard     = optional(bool, false)
	}))
	default = []
}

# ==================================================================
# RESEAU PHYSIQUE (NIC)
# ==================================================================

variable "vnic_model" {
  description   = "Modèle de la carte réseau virtuelle à utiliser pour la VM clonée (ex: virtio, e1000)"
    type        = string
    default     = "e1000"
}

variable "vnic_bridge" {
    description = "Pont réseau à utiliser pour la carte réseau virtuelle de la VM clonée (ex: vmbr0)"
    type        = string
}

variable "vlan_tag" {
    description = "ID de VLAN à utiliser pour la carte réseau virtuelle de la VM clonée (ex: 100)"
    type        = number
    default     = 0
}

# ==================================================================
# INITIALISATION (CLOUD-INIT)
# ==================================================================
# --- FICHIERS DE CONFIGURATION ---
variable "ci_datastore_id" {
    description = "ID du datastore pour les données d'initialisation de la VM clonée"
    type        = string
    default     = ""
}

variable "ci_meta_data_file_id" {
    description = "ID du fichier de métadonnées d'initialisation de la VM clonée"
    type        = string
    default     = ""
}

variable "ci_network_config_file_id" {
    description = "ID du fichier de configuration réseau d'initialisation de la VM clonée"
    type        = string
    default     = ""
}

variable "ci_user_data_file_id" {
    description = "ID du fichier de données utilisateur d'initialisation de la VM clonée"
    type        = string
    default     = ""
}

variable "ci_vendor_data_file_id" {
  description = "ID du fichier de données fournisseur d'initialisation de la VM clonée"
  type        = string
  default     = ""
}

# --- PARAMETRES OS ---
variable "user_account_username" {
    description = "Nom d'utilisateur pour le compte utilisateur de la VM clonée"
    type        = string
    default     = ""
}

variable "user_account_ssh_public_keys" {
    description = "Liste des clés SSH publiques à ajouter au compte utilisateur de la VM clonée"
    type        = list(string)
    default     = []
}

variable "dns_domain" {
    description = "Domaine DNS à configurer pour la VM clonée"
    type        = string
    default     = ""
}

variable "dns_servers" {
    description = "Liste des serveurs DNS à configurer pour la VM clonée"
    type        = list(string)
    default     = []
}

variable "ipv4_address" {
    description = "Adresse IPv4 à configurer pour la VM clonée"
    type        = string
    default     = ""
}

variable "ipv4_gateway" {
    description = "Passerelle IPv4 à configurer pour la VM clonée"
    type        = string
    default     = ""
}

variable "ipv4_cidr" {
  description = "CIDR de l'adresse IPv4 à configurer pour la VM clonée"
  type        = string
  default     = ""
}