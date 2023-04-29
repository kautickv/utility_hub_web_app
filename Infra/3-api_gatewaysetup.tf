resource "aws_api_gateway_rest_api" "password_generator_api_gateway" {
  name = "password_generator_api_gateway"
  description = "REST API gateway for password_generator app. "
}

resource "aws_api_gateway_resource" "password_generator_api_gateway_home_resource" {
  parent_id   = aws_api_gateway_rest_api.password_generator_api_gateway.root_resource_id
  path_part   = "home"
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
}