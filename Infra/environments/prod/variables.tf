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

variable "dns_aws_access_key_id" {
  description = "AWS Access Key ID for DNS Account"
  type        = string
}

variable "dns_aws_secret_access_key" {
  description = "AWS Secret Access Key for DNS Account"
  type        = string
}

variable "dns_aws_session_token" {
  description = "AWS Session Token for DNS Account"
  type        = string
}