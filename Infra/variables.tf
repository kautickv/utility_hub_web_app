# All variables related to S3 bucket static hosting
variable "domain_name"{
    type = string
    description = "The domain name of the website"
}


variable "bucket_name" {
    type = string
    description = "The name of the bucket with the www. prefix. Same as domain name"
}


# All variables related to cloudfront and route53 hosting
variable "SSL_certificate_arn" {
  type = string
  description = "The ARN for the SSL certificate to be used by cloudfront. Terraform script does not create a request certificate"
}

variable "hosted_zone_id" {
    type = string
    description = "The hosted zone ID into which record will be created."
}


# All other variables
variable "common_tags"{
    description = "Common tags you want to apply to all components"
}