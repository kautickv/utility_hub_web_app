# Create a REST API gateway in AWS
resource "aws_api_gateway_rest_api" "password_generator_api_gateway" {
  name = "password_generator_api_gateway"
  description = "REST API gateway for password_generator app. "
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

# Integrate the above get method
resource "aws_api_gateway_integration" "get_home_integration" {
  http_method = aws_api_gateway_method.get_home_method.http_method
  resource_id = aws_api_gateway_resource.password_generator_api_gateway_home_resource.id
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
  type        = "MOCK"
}

# Deploy for above api
resource "aws_api_gateway_deployment" "password_generator_api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.example.id

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