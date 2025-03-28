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

variable "region" {
  description = "Default AWS region"
  type = string
}

variable "use_vpc" {
  description = "True or False boolean to use VPC setup or not"
  type        = bool
}

