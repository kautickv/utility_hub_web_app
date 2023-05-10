# All variables related to S3 bucket static hosting
variable "domain_name"{
    type = string
    description = "The domain name of the website"
}


variable "bucket_name" {
    type = string
    description = "The name of the bucket with the www. prefix. Same as domain name"
}

variable "common_tags"{
    description = "Common tags you want to apply to all components"
}