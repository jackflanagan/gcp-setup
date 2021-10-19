module "networking" {
  source = "./modules/networking"

}

module "application_instances" {
  source = "./modules/application"

  subnet_name = module.networking.subnet_name

}

module "tools" {
  source = "./modules/tools"

  subnet_name = module.networking.subnet_name
  external_ip = module.networking.external_ip

}