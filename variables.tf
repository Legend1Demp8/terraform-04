###cloud vars
#variable "token" {
#  type        = string
#  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
#}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

###common vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "your_ssh_ed25519_key"
  description = "ssh-keygen -t ed25519"
}

###example vm_web var
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "example vm_web_ prefix"
}

###example vm_db var
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "example vm_db_ prefix"
}


variable "vm_marketing_config" {
  type = object({
    env_name           = string
    subnet_zones       = list(string)
    instance_name      = string
    instance_count     = number
    platform           = string
    image_family       = string
    public_ip          = bool
    serial_port_enable = number
    project_label      = string
  })
  default = {
    env_name           = "develop"
    subnet_zones       = ["ru-central1-d"]
    instance_name      = "marketing-vm"
    instance_count     = 1
    platform           = "standard-v2"
    image_family       = "ubuntu-2004-lts"
    public_ip          = true
    serial_port_enable = 1
    project_label      = "marketing"
  }
  description = "Конфигурация модуля маркетинговой ВМ"
}

variable "vm_analytics_config" {
  type = object({
    env_name           = string
    subnet_zones       = list(string)
    instance_name      = string
    instance_count     = number
    platform           = string
    image_family       = string
    public_ip          = bool
    serial_port_enable = number
    project_label      = string
  })
  default = {
    env_name           = "stage"
    subnet_zones       = ["ru-central1-d"]
    instance_name      = "analytics-vm"
    instance_count     = 1
    platform           = "standard-v2"
    image_family       = "ubuntu-2004-lts"
    public_ip          = true
    serial_port_enable = 1
    project_label      = "analytics"
  }
  description = "Конфигурация модуля аналитической ВМ"
}

variable "marketing_vpc_config" {
  type = object({
    network_name   = string
    zone           = string
    v4_cidr_blocks = list(string)
  })
  default = {
    network_name   = "marketing"
    zone           = "ru-central1-d"
    v4_cidr_blocks = ["10.10.10.0/24"]
  }
  description = "Настройки сети VPC для проекта marketing"
}
