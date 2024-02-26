variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}


variable "force_destroy" {
  description = "Force destroy flag for bucket"
  default     = false
  type        = bool
}
