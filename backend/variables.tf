variable "rg_name_backend" {
  type = string
  description = "Name of the resource group"
}

variable "rg_backend_location" {
  type = string
  description = "Deployment location"
}

variable "az_sa_name" {
  type = string
  description = "Name of the storage account "
}

variable "az_sc_backend_name" {
  type = string
  description = "Name of the storage container"
}

variable "sa_backend_accesskey_name" {
  type = string
  description = "Name of the storage account key for the backend"
}