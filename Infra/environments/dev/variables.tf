variable "bucket_name" {
  description = "Name of S3 Static bucket hosting"
  type        = string
}

variable "domain_name" {
    description = "Domain name of website"
    type = string
}

variable "hosted_zone_id"{
    description = "The ID for the hosted zone"
    type = string
}

variable "app_name"{
  description = "The name of the application"
  type = string
  default = "Test_App"
}
