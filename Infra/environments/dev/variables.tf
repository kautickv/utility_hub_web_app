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

variable "aws_access_key_id_1" {}
variable "aws_secret_access_key_1" {}
variable "aws_session_token_1" {}

variable "aws_access_key_id_2" {}
variable "aws_secret_access_key_2" {}
variable "aws_session_token_2" {}
