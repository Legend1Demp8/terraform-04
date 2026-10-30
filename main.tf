#создаем облачную сеть
#resource "yandex_vpc_network" "develop" {
#  name = "develop"
#}
#
##создаем подсеть
#resource "yandex_vpc_subnet" "develop_1" {
#  name           = "develop-1-ru-central1-d"
#  zone           = "ru-central1-d"
#  network_id     = yandex_vpc_network.develop.id
#  v4_cidr_blocks = ["10.0.1.0/24"]
#}
#
#resource "yandex_vpc_subnet" "develop_2" {
#  name           = "develop-2-ru-central1-d"
#  zone           = "ru-central1-d"
#  network_id     = yandex_vpc_network.develop.id
#  v4_cidr_blocks = ["10.0.2.0/24"]
#}

module "vm_marketing" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=v2.0.0"
  env_name       = var.vm_marketing_config.env_name
  network_id     = module.marketing_vpc.network.id
  subnet_zones   = var.vm_marketing_config.subnet_zones
  subnet_ids     = [module.marketing_vpc.subnet.id]
  instance_name  = var.vm_marketing_config.instance_name
  instance_count = var.vm_marketing_config.instance_count
  platform       = var.vm_marketing_config.platform
  image_family   = var.vm_marketing_config.image_family
  public_ip      = var.vm_marketing_config.public_ip

  labels = {
    project = var.vm_marketing_config.project_label
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = var.vm_marketing_config.serial_port_enable
  }
}

# Вторая ВМ - проект analytics
module "vm_analytics" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=v2.0.0"
  env_name       = var.vm_analytics_config.env_name
  network_id     = module.marketing_vpc.network.id
  subnet_zones   = var.vm_analytics_config.subnet_zones
  subnet_ids     = [module.marketing_vpc.subnet.id]
  instance_name  = var.vm_analytics_config.instance_name
  instance_count = var.vm_analytics_config.instance_count
  platform       = var.vm_analytics_config.platform
  image_family   = var.vm_analytics_config.image_family
  public_ip      = var.vm_analytics_config.public_ip

  labels = {
    project = var.vm_analytics_config.project_label
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = var.vm_analytics_config.serial_port_enable
  }
}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
    ssh_public_key = local.ssh_public_key
  }
}

module "marketing_vpc" {
  source = "./modules/vpc"

  network_name   = var.marketing_vpc_config.network_name
  zone           = var.marketing_vpc_config.zone
  v4_cidr_blocks = var.marketing_vpc_config.v4_cidr_blocks
}
