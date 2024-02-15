output "resource_id" {
  value = aws_api_gateway_resource.api_gateway_new_resource.id
}

output "options_method"{
  value = aws_api_gateway_method.options_new_method
}

output "options_http_method" {
  value = aws_api_gateway_method.options_new_method.http_method
}