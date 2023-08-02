# Add a resource to that API gateway called home
resource "aws_api_gateway_resource" "password_generator_api_gateway_home_resource" {
  parent_id   = aws_api_gateway_rest_api.password_generator_api_gateway.root_resource_id
  path_part   = "home"
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

# Add Options method for home resource
resource "aws_api_gateway_method" "options_home_method" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_home_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  http_method   = aws_api_gateway_method.options_home_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options_home_method]
}

resource "aws_api_gateway_integration" "options_home_integration" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  http_method   = aws_api_gateway_method.options_home_method.http_method
  type          = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  depends_on    = [aws_api_gateway_method.options_home_method]
}

resource "aws_api_gateway_integration_response" "options_home_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  http_method   = aws_api_gateway_method.options_home_method.http_method
  status_code   = aws_api_gateway_method_response.options_home_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [
    aws_api_gateway_method_response.options_home_method_response_200,
    aws_api_gateway_integration.options_home_integration
    ]
}

# Add a GET method to "home" resource created above
resource "aws_api_gateway_method" "get_home_method" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

resource "aws_api_gateway_method_response" "get_home_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  http_method   = aws_api_gateway_method.get_home_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = [aws_api_gateway_method.get_home_method]
}

# Add permissions for API Gateway to invoke lambda
resource "aws_lambda_permission" "lambda_permission" {
  statement_id    = "AllowBackendLambdaInvoke"
  action          = "lambda:InvokeFunction"
  function_name   = aws_lambda_function.home-backend-lambda-function.function_name
  principal       = "apigateway.amazonaws.com"
  source_arn      = "${aws_api_gateway_rest_api.password_generator_api_gateway.execution_arn}/*"
}

# Integrate the above GET method with our backend lambda function created earlier
resource "aws_api_gateway_integration" "get_home_integration" {
  http_method             = aws_api_gateway_method.get_home_method.http_method
  resource_id             = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  rest_api_id             = aws_api_gateway_rest_api.password_generator_api_gateway.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.home-backend-lambda-function.invoke_arn
}
