# Add method to resource
resource "aws_api_gateway_method" "new_method" {
  authorization = var.authorization
  http_method   = var.http_method
  resource_id   = var.resource_id
  rest_api_id   = var.rest_api_id
}

resource "aws_api_gateway_method_response" "new_method_response_200" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.resource_id
  http_method   = aws_api_gateway_method.new_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
  depends_on = [aws_api_gateway_method.new_method]
}

resource "aws_api_gateway_method_response" "options_new_method_response_200" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.resource_id
  http_method   = var.resource_options_http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "options_new_method_integration" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.resource_id
  http_method   = var.resource_options_http_method
  type          = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "options_new_method_integration_response" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.resource_id
  http_method   = var.resource_options_http_method
  status_code   = aws_api_gateway_method_response.options_new_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [
    aws_api_gateway_method_response.options_new_method_response_200,
    aws_api_gateway_integration.options_new_method_integration

    ]
}
