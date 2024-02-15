# Create a REST API gateway in AWS
resource "aws_api_gateway_rest_api" "utility_hub_api_gateway" {
  name        = "utility_hub_api_gateway"
  description = "REST API gateway for Utility Hub app."
}

# create a new resource called "auth" inside api gateway
module "auth_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = aws_api_gateway_rest_api.utility_hub_api_gateway.root_resource_id
  path_part = "auth"
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
}

# Create a new resource called "creds" inside inside auth resource
module "creds_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = module.auth_resource.resource_id
  path_part = "creds"
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id

}

# Create a GET Creds method inside "creds" resource
module "get_creds_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
  authorization = "NONE"
  http_method = "GET"
  resource_id = module.creds_resource.resource_id
  resource_options_method = module.creds_resource.options_method
  resource_options_http_method = module.creds_resource.options_http_method
}