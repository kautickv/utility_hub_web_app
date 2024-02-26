variable "statement_id" {
  description = "A unique identifier for the statement. It's used to differentiate between multiple statements in a single policy document."
  type = string
}
variable "function_name" {
  description = "The name of the Lambda function to which the permissions are being granted."
  type = string
}
variable "source_arn" {
  description = "The ARN of the source resource that is allowed to invoke the Lambda function."
  type = string
}
variable "http_method" {
  description = "HTTP Method for the API method"
  type = string
}
variable "resource_id" {
  description = "Resource ID for method"
  type = string
}
variable "rest_api_id" {
  description = "API gateway ID"
  type = string
}
variable "lambda_invoke_arn" {
  description = "Invoke ARN of lambda"
  type = string
}

