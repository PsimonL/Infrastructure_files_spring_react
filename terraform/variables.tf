variable "serviceprinciple_id" {
  description = "ID Principal Service"
  type        = string
}

variable "serviceprinciple_key" {
  description = "Klucz Principal Service"
  type        = string
}

variable "tenant_id" {
  description = "ID Tenanta"
  type        = string
}

variable "subscription_id" {
  description = "ID Subskrypcji"
  type        = string
}

variable "ssh_key" {
  description = "Klucz SSH"
  type        = string
}

variable "location" {
  description = "Region Azure"
  default     = "East US"
}

variable "kubernetes_version" {
  description = "Wersja Kubernetes"
  default     = "1.22.2"
}
