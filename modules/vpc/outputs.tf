output "network" {
  value       = yandex_vpc_network.this
  description = "Объект созданной сети VPC со всеми атрибутами"
}

output "subnet" {
  value       = yandex_vpc_subnet.this
  description = "Объект созданной подсети со всеми атрибутами"
}
