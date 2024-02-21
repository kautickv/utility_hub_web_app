variable "layer_s3_bucket_id" {
  description = "The bucket name to which the file will be uploaded"
  type = string
}

variable "key" {
  description = "The file path within the bucket to which the file will be uploaded"
  type = string
}

variable "file_source" {
  description = "The path to the file on local"
  type = string
}

variable "layer_name" {
  description = "The name of the layer"
  type = string
}