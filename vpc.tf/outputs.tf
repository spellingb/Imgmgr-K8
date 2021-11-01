output "Ciderblock" {
  value = "${var.CiderBlock}.0.0/16"
}
output "pub_networks" {
  value = local.pub_networks
}
output "priv_networks" {
  value = local.priv_networks
}
output "VPC_Name" {
  value = "${var.namespace}-${var.environment}-VPC"
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnet_list" {
  value = module.vpc.public_subnets
}
output "private_subnet_list" {
  value = module.vpc.private_subnets
}