variable "network_name" {
  type        = string
  description = "Название создаваемой сети"
}

variable "zone" {
  type        = string
  description = "Зона доступности для подсети (например, ru-central1-a)"
}

variable "v4_cidr_blocks" {
  type        = list(string)
  description = "CIDR блоки для подсети"
}
