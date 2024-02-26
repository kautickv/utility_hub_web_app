# Create a resource inside parent resource
resource "aws_api_gateway_resource" "api_gateway_new_resource" {
  parent_id   = var.parent_resource_id
  path_part   = var.path_part
  rest_api_id = var.rest_api_id
}
# Add Options method for new resource
resource "aws_api_gateway_method" "options_new_method" {
  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.api_gateway_new_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_method_response_200" {
  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.api_gateway_new_resource.id
  http_method   = aws_api_gateway_method.options_new_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options_new_method]
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.api_gateway_new_resource.id
  http_method   = aws_api_gateway_method.options_new_method.http_method
  type          = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  depends_on    = [aws_api_gateway_method.options_new_method]
}

resource "aws_api_gateway_integration_response" "options_integration_response_resource" {
  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.api_gateway_new_resource.id
  http_method   = aws_api_gateway_method.options_new_method.http_method
  status_code   = aws_api_gateway_method_response.options_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [
    aws_api_gateway_method_response.options_method_response_200,
    aws_api_gateway_integration.options_integration

    ]
}