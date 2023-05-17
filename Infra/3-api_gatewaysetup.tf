# Create a REST API gateway in AWS
resource "aws_api_gateway_rest_api" "password_generator_api_gateway" {
  name = "${var.app_name}_api_gateway"
  description = "REST API gateway for ${var.app_name} app. "

}

# Add an OPTIONS method to "home" resource for CORS
resource "aws_api_gateway_method" "options_home_method" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# Add a method response for the OPTIONS method
resource "aws_api_gateway_method_response" "success_options_home_method" {
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  http_method = aws_api_gateway_method.options_home_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false,
    "method.response.header.Access-Control-Allow-Methods" = false,
    "method.response.header.Access-Control-Allow-Origin"  = false,
  }
}

# Add an integration response for the OPTIONS method
resource "aws_api_gateway_integration" "options_home_integration" {
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  http_method = aws_api_gateway_method.options_home_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "options_home_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  http_method = aws_api_gateway_method.options_home_method.http_method
  status_code = aws_api_gateway_method_response.success_options_home_method.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}


# Add a resource to that API gateway called home
resource "aws_api_gateway_resource" "password_generator_api_gateway_home_resource" {
  parent_id   = aws_api_gateway_rest_api.password_generator_api_gateway.root_resource_id
  path_part   = "home"
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

# Add a GET method to "home" resource created above
resource "aws_api_gateway_method" "get_home_method" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

# Add permissions for api gateway to invoke lambda
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowBackendLambdaInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.password-generator-backend-lambda-function.function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_api_gateway_rest_api.password_generator_api_gateway.execution_arn}/*"
}

# Integrate the above get method with our backend lambda function created earlier.
resource "aws_api_gateway_integration" "get_home_integration" {
  http_method = aws_api_gateway_method.get_home_method.http_method
  resource_id = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.password-generator-backend-lambda-function.invoke_arn

}

# Deploy for above api
resource "aws_api_gateway_deployment" "password_generator_api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.password_generator_api_gateway_home_resource.id,
      aws_api_gateway_method.get_home_method.id,
      aws_api_gateway_integration.get_home_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

#Deploy in a staging environment called "dev"
resource "aws_api_gateway_stage" "password_generator_api_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.password_generator_api_gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  stage_name    = "dev"
}

# Print the invoke url for /home on terminal
output "invoke_url" {
  value = aws_api_gateway_stage.password_generator_api_gateway_stage.invoke_url
}




