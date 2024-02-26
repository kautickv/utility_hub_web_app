output "method_id" {
    value = aws_api_gateway_method.new_method.id
}

output "http_method"{
    value = aws_api_gateway_method.new_method.http_method
}
