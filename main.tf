#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = "develop"
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop_1" {
  name           = "develop-1-ru-central1-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "develop_2" {
  name           = "develop-2-ru-central1-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

# Первая ВМ - проект marketing
module "vm_marketing" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop"
  network_id     = module.marketing_vpc.network_id #yandex_vpc_network.develop.id
  subnet_zones   = ["ru-central1-d"]
  subnet_ids     = [module.marketing_vpc.subnet_id] #[yandex_vpc_subnet.develop_d.id] # Укажите вашу подсеть
  instance_name  = "marketing-vm"
  instance_count = 1
  platform       = "standard-v2"
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = {
    project = "marketing"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

# Вторая ВМ - проект analytics
module "vm_analytics" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "stage"
  network_id     = module.marketing_vpc.network_id #yandex_vpc_network.develop.id
  subnet_zones   = ["ru-central1-d"]
  subnet_ids     = [module.marketing_vpc.subnet_id] #[yandex_vpc_subnet.develop_e.id] # Укажите вашу подсеть
  instance_name  = "analytics-vm"
  instance_count = 1
  platform       = "standard-v2"
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = {
    project = "analytics"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
    ssh_public_key = local.ssh_public_key
  }
}




######## Задание 2
########
module "marketing_vpc" {
  source = "./modules/vpc"

  network_name   = "marketing"
  zone           = "ru-central1-d"
  v4_cidr_blocks = ["10.10.10.0/24"]
}

