variable "rest_api_id" {
  description = "API Gateway Id"
  type        = string
}

variable "authorization" {
  description = "Authorization type for the method"
  type        = string
  default = "NONE"
}

variable "http_method" {
  description = "HTTP Method for the method"
  type        = string
  default = "GET"
}

variable "resource_id" {
  description = "Resource ID into which to create method"
  type        = string
}

variable "resource_options_method" {
  description = "Options method for resource"
  type        = string
}

variable "resource_options_http_method" {
    description = "HTTP Method for resource options method"
    type = string
}
