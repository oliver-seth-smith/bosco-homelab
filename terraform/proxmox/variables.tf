variable "proxmox_endpoint" {
  description = "Proxmox API endpoint, for example https://pve.example.com:8006/api2/json"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token in provider-supported format."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Allow self-signed Proxmox certificate during lab bootstrap."
  type        = bool
  default     = true
}

