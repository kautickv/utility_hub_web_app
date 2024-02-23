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
  default = "Utility_hub"
}

variable "aws_access_key_id_1" {
  description = "AWS Access Key ID for Account 1"
  type        = string
}

variable "aws_secret_access_key_1" {
  description = "AWS Secret Access Key for Account 1"
  type        = string
}

variable "aws_session_token_1" {
  description = "AWS Session Token for Account 1"
  type        = string
}

variable "aws_access_key_id_2" {
  description = "AWS Access Key ID for Account 2"
  type        = string
}

variable "aws_secret_access_key_2" {
  description = "AWS Secret Access Key for Account 2"
  type        = string
}

variable "aws_session_token_2" {
  description = "AWS Session Token for Account 2"
  type        = string
}

