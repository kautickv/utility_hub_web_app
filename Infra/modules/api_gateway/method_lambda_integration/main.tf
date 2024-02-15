# Add permissions for API Gateway to invoke lambda
resource "aws_lambda_permission" "lambda_permission" {
  statement_id    = var.statement_id
  action          = "lambda:InvokeFunction"
  function_name   = var.function_name
  principal       = "apigateway.amazonaws.com"
  source_arn      = var.source_arn
}

# Integrate the method with our lambda function
resource "aws_api_gateway_integration" "method_integration" {
  http_method             = var.http_method
  resource_id             = var.resource_id
  rest_api_id             = var.rest_api_id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn
}