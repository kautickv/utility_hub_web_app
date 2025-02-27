## Global Variables
##-------------------------------------------------------------------------------------
variable "app_name"{
  description = "The name of the application"
  type = string
  default = "utility_hub"
}

variable "domain_name" {
    description = "Domain name of website"
    type = string
}

variable "bucket_name" {
  description = "Name of S3 Static bucket hosting"
  type        = string
}


variable "hosted_zone_id"{
    description = "The ID for the hosted zone"
    type = string
}


## Deployments Variables
##-------------------------------------------------------------------------------------

variable "aws_default_region" {
  description = "AWS region for the default provider"
  type        = string
  default     = "us-east-1"
}

variable "dns_account_region" {
  description = "AWS region for the DNS account provider"
  type        = string
  default     = "us-east-1"
}

variable "dns_iam_role_arn"{
  description = "AWS Role to be used to deploy DNS configurations to hosted zone"
  type = string
}

variable "default_iam_role_arn"{
  description = "AWS Role to be used to deploy entire infrastructure"
  type = string
}

variable "use_vpc" {
  description = "True or False boolean to use VPC setup or not"
  type        = bool
  default = false
}
