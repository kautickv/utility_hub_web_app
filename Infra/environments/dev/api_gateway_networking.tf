# Create a REST API gateway in AWS
resource "aws_api_gateway_rest_api" "utility_hub_api_gateway" {
  name        = "utility_hub_api_gateway"
  description = "REST API gateway for Utility Hub app."
}

## AUTH RESOURCE
##------------------------------------------------------------------------------------
# create a new resource called "auth" inside api gateway
module "auth_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = aws_api_gateway_rest_api.utility_hub_api_gateway.root_resource_id
  path_part = "auth"
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
}

## CREDS RESOURCE
##------------------------------------------------------------------------------------
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
  resource_options_method = module.creds_resource.options_method_id
  resource_options_http_method = module.creds_resource.options_http_method
}

# Configure GET /auth/creds to invoke auth lambda
module "get_creds_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowAuthBackendLambdaInvoke"
  function_name = module.auth_lamda_function.function_name
  source_arn = "${aws_api_gateway_rest_api.utility_hub_api_gateway.execution_arn}/*"
  http_method = module.get_creds_method.http_method
  resource_id = module.creds_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
  lambda_invoke_arn = module.auth_lamda_function.invoke_arn
}

## VERIFY RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "verify" inside inside auth resource
module "verify_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = module.auth_resource.resource_id
  path_part = "verify"
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
}

# Create a POST method inside "verify" resource
module "post_verify_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
  authorization = "NONE"
  http_method = "POST"
  resource_id = module.verify_resource.resource_id
  resource_options_method = module.verify_resource.options_method_id
  resource_options_http_method = module.verify_resource.options_http_method
}

# Configure POST /auth/verify to invoke auth lambda
module "post_verify_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowAuthBackendLambdaInvoke"
  function_name = module.auth_lamda_function.function_name
  source_arn = "${aws_api_gateway_rest_api.utility_hub_api_gateway.execution_arn}/*"
  http_method = module.post_verify_method.http_method
  resource_id = module.verify_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
  lambda_invoke_arn = module.auth_lamda_function.invoke_arn
}

## LOGIN RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "login" inside inside auth resource
module "login_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = module.auth_resource.resource_id
  path_part = "login"
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
}

# Create a POST method inside "login" resource
module "post_login_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
  authorization = "NONE"
  http_method = "POST"
  resource_id = module.login_resource.resource_id
  resource_options_method = module.login_resource.options_method_id
  resource_options_http_method = module.login_resource.options_http_method
}

# Configure POST /auth/login to invoke auth lambda
module "post_login_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowAuthBackendLambdaInvoke"
  function_name = module.auth_lamda_function.function_name
  source_arn = "${aws_api_gateway_rest_api.utility_hub_api_gateway.execution_arn}/*"
  http_method = module.post_login_method.http_method
  resource_id = module.login_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
  lambda_invoke_arn = module.auth_lamda_function.invoke_arn
}

## LOGOUT RESOURCE
##------------------------------------------------------------------------------------
# Create a new resource called "logout" inside inside auth resource
module "logout_resource" {
  source = "../../modules/api_gateway/api_gateway_resource"
  parent_resource_id = module.auth_resource.resource_id
  path_part = "logout"
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
}

# Create a POST method inside "logout" resource
module "post_logout_method" {
  source = "../../modules/api_gateway/api_gateway_method"
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
  authorization = "NONE"
  http_method = "POST"
  resource_id = module.logout_resource.resource_id
  resource_options_method = module.logout_resource.options_method_id
  resource_options_http_method = module.logout_resource.options_http_method
}

# Configure POST /auth/logout to invoke auth lambda
module "post_logout_lambda_integration" {
  source = "../../modules/api_gateway/method_lambda_integration"

  statement_id = "AllowAuthBackendLambdaInvoke"
  function_name = module.auth_lamda_function.function_name
  source_arn = "${aws_api_gateway_rest_api.utility_hub_api_gateway.execution_arn}/*"
  http_method = module.post_logout_method.http_method
  resource_id = module.logout_resource.resource_id
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id
  lambda_invoke_arn = module.auth_lamda_function.invoke_arn
}


## DEPLOY API GATEWAY
##------------------------------------------------------------------------------------
# Deploy the API gateway
resource "aws_api_gateway_deployment" "utility_hub_api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.utility_hub_api_gateway.id

  triggers = {
    //Added this to trigger a re-deployment everytime terraform script runs.
    last_modified = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
      module.get_creds_lambda_integration,
      module.post_verify_lambda_integration,
      module.post_login_lambda_integration,
      post_logout_lambda_integration

  ]
}

# Deploy in a staging environment called "dev"
resource "aws_api_gateway_stage" "utility_hub_api_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.utility_hub_api_gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.utility_hub_api_gateway.id
  stage_name    = "dev"
}

# Print the invoke URL for /auth/creds on terminal
output "invoke_url" {
  value = aws_api_gateway_stage.utility_hub_api_gateway_stage.invoke_url
}