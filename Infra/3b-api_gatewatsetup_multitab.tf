# Add a resource to that API gateway called multitab
resource "aws_api_gateway_resource" "password_generator_api_gateway_multitab_resource" {
  parent_id   = aws_api_gateway_rest_api.password_generator_api_gateway.root_resource_id
  path_part   = "multitab"
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

# Add Options method for multitab resource
resource "aws_api_gateway_method" "options_multitab_method" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_multitab_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_multitab_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_multitab_resource.id
  http_method   = aws_api_gateway_method.options_multitab_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options_multitab_method]
}

resource "aws_api_gateway_integration" "options_multitab_integration" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_multitab_resource.id
  http_method   = aws_api_gateway_method.options_multitab_method.http_method
  type          = "MOCK"
  depends_on    = [aws_api_gateway_method.options_multitab_method]
}

resource "aws_api_gateway_integration_response" "options_multitab_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_multitab_resource.id
  http_method   = aws_api_gateway_method.options_multitab_method.http_method
  status_code   = aws_api_gateway_method_response.options_multitab_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.options_multitab_method_response_200]
}

# Add a POST method to "multitab" resource created above
resource "aws_api_gateway_method" "post_multitab_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_multitab_resource.id
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

resource "aws_api_gateway_method_response" "post_multitab_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_multitab_resource.id
  http_method   = aws_api_gateway_method.post_multitab_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
  depends_on = [aws_api_gateway_method.post_multitab_method]
}

# Add permissions for API Gateway to invoke multitab lambda POST request
resource "aws_lambda_permission" "post_multitab_lambda_permission" {
  statement_id    = "AllowPostMultitabLambdaInvoke"
  action          = "lambda:InvokeFunction"
  function_name   = aws_lambda_function.multitab-backend-lambda-function.function_name
  principal       = "apigateway.amazonaws.com"
  source_arn      = "${aws_api_gateway_rest_api.password_generator_api_gateway.execution_arn}/${aws_api_gateway_method.post_multitab_method.http_method}/multitab"
}

# Integrate the above POST method with our multitab backend lambda function created earlier
resource "aws_api_gateway_integration" "post_multitab_integration" {
  http_method             = aws_api_gateway_method.post_multitab_method.http_method
  resource_id             = aws_api_gateway_resource.password_generator_api_gateway_multitab_resource.id
  rest_api_id             = aws_api_gateway_rest_api.password_generator_api_gateway.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.multitab-backend-lambda-function.invoke_arn
}

# Add a GET method to "multitab" resource
resource "aws_api_gateway_method" "get_multitab_method" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_multitab_resource.id
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

resource "aws_api_gateway_method_response" "get_multitab_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_multitab_resource.id
  http_method   = aws_api_gateway_method.get_multitab_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
  depends_on = [aws_api_gateway_method.get_multitab_method]
}

# Add permissions for API Gateway to invoke multitab lambda GET request
resource "aws_lambda_permission" "get_multitab_lambda_permission" {
  statement_id    = "AllowGetMultitabLambdaInvoke"
  action          = "lambda:InvokeFunction"
  function_name   = aws_lambda_function.multitab-backend-lambda-function.function_name
  principal       = "apigateway.amazonaws.com"
  source_arn      = "${aws_api_gateway_rest_api.password_generator_api_gateway.execution_arn}/${aws_api_gateway_method.get_multitab_method.http_method}/multitab"
}

# Integrate the above GET method with our multitab backend lambda function created earlier
resource "aws_api_gateway_integration" "get_multitab_integration" {
  http_method             = aws_api_gateway_method.get_multitab_method.http_method
  resource_id             = aws_api_gateway_resource.password_generator_api_gateway_multitab_resource.id
  rest_api_id             = aws_api_gateway_rest_api.password_generator_api_gateway.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.multitab-backend-lambda-function.invoke_arn
}


