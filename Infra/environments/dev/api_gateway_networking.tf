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