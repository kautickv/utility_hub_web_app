variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "s3_bucket_id" {
  description = "The S3 bucket ID where the Lambda function code is stored"
  type        = string
}

variable "s3_bucket_key" {
  description = "The S3 key of the Lambda function code"
  type        = string
}

variable "handler_name" {
  description = "The handler name of the Lambda function"
  type        = string
}

variable "source_code_hash" {
  description = "The base64-encoded SHA256 hash of the package file"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role attached to the Lambda function"
  type        = string
}

variable "layers_arn" {
  description = "A list of Lambda layer ARNs to attach to the Lambda function"
  type        = list(string)
  default = []
}

variable "environment_variables" {
  description = "A map of environment variables for the Lambda function"
  type        = map(string)
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds"
  type        = number
  default     = 15
}

variable "memory_size" {
  description = "The amount of memory available to the Lambda function in MB"
  type        = number
  default     = 128
}

variable "use_vpc" {
  description = "True or False boolean to use VPC setup or not"
  type        = bool
}

