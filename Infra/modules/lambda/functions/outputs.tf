output "resource_id" {
  value = aws_lambda_function.lamda_function.function_name
}
output "invoke_arn" {
  value = aws_lambda_function.lamda_function.invoke_arn
}