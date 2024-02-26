## Build entire Dev Infra
module "build_dev_infra" {

    source = "../../modules/shared"

    app_name = var.app_name
    bucket_name = var.bucket_name
    domain_name = var.domain_name
    hosted_zone_id= var.hosted_zone_id
}