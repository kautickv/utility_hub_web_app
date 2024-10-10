module "setup_vpc_network" {
    count = var.use_vpc? 1 : 0
    source = "../../modules/vpc_setup"
    app_name = var.app_name
    region = var.region
}