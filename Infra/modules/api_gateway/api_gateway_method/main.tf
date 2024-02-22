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


