variable "name" {
  description = "The name of the table"
  type        = string
}

variable "billing_mode" {
  description = "Controls how you are charged for read and write throughput"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "The attribute to use as the hash key"
  type        = string
}

variable "attributes" {
  description = "A list of attributes"
  type        = list(map(string))
}

variable "region"{
  description = "The region of the table"
  type = string
}

variable "global_secondary_indexes" {
  description = "A list of global secondary indexes"
  type        = list(map(any))
  default     = []
}


