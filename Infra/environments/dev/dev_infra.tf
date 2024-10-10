## Build entire Dev Infra
module "build_dev_infra" {

    source = "../../modules/shared"

    providers = {
        aws.acm   = aws.acm
        aws.dns_account = aws.dns_account
    }

    app_name = var.app_name
    bucket_name = var.bucket_name
    domain_name = var.domain_name
    hosted_zone_id= var.hosted_zone_id
    region = var.aws_default_region
    use_vpc = false
}