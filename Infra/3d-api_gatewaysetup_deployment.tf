# Deploy the API gateway
resource "aws_api_gateway_deployment" "password_generator_api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.password_generator_api_gateway_home_resource.id,
      aws_api_gateway_method.get_home_method.id,
      aws_api_gateway_integration.get_home_integration.id,
      aws_api_gateway_method.options_home_method.id,
      aws_api_gateway_method_response.options_home_method_response_200.id,
      aws_api_gateway_integration.options_home_integration.id,
      aws_api_gateway_integration_response.options_home_integration_response.id,
      aws_api_gateway_resource.password_generator_api_gateway_multitab_resource.id,
      aws_api_gateway_method.post_multitab_method.id,
      aws_api_gateway_method_response.post_multitab_method_response_200.id,
      aws_api_gateway_integration.post_multitab_integration.id,
      aws_api_gateway_integration_response.post_multitab_integration_response.id,
      aws_lambda_permission.post_multitab_lambda_permission.id,
      aws_api_gateway_method.options_multitab_method.id,
      aws_api_gateway_method_response.options_multitab_method_response_200.id,
      aws_api_gateway_integration.options_multitab_integration.id,
      aws_api_gateway_integration_response.options_multitab_integration_response.id,
      aws_api_gateway_method.get_multitab_method.id,
      aws_api_gateway_method_response.get_multitab_method_response_200.id,
      aws_api_gateway_integration.get_multitab_integration.id,
      aws_lambda_permission.get_multitab_lambda_permission.id,
      aws_api_gateway_resource.password_generator_api_gateway_auth_resource.id,
      aws_api_gateway_resource.password_generator_api_gateway_creds_resource.id,
      aws_api_gateway_method.get_creds_method.id,
      aws_api_gateway_integration.get_creds_integration.id,
      aws_api_gateway_resource.password_generator_api_gateway_verify_resource.id,
      aws_api_gateway_method.post_verify_method.id,
      aws_api_gateway_integration.post_verify_integration.id,
      aws_api_gateway_resource.password_generator_api_gateway_login_resource.id,
      aws_api_gateway_method.post_login_method.id,
      aws_api_gateway_integration.post_login_integration.id,
      aws_api_gateway_resource.password_generator_api_gateway_logout_resource.id,
      aws_api_gateway_method.post_logout_method.id,
      aws_api_gateway_integration.post_logout_integration.id,
      aws_api_gateway_rest_api.password_generator_api_gateway.root_resource_id,
      aws_api_gateway_method.options_auth_method.id,
      aws_api_gateway_method_response.options_auth_method_response_200.id,
      aws_api_gateway_integration.options_auth_integration.id,
      aws_api_gateway_integration_response.options_auth_integration_response.id,
      aws_api_gateway_method.options_creds_method.id,
      aws_api_gateway_method_response.options_creds_method_response_200.id,
      aws_api_gateway_integration.options_creds_integration.id,
      aws_api_gateway_integration_response.options_creds_integration_response.id,
      aws_api_gateway_method.options_verify_method.id,
      aws_api_gateway_method_response.options_verify_method_response_200.id,
      aws_api_gateway_integration.options_verify_integration.id,
      aws_api_gateway_integration_response.options_verify_integration_response.id,
      aws_api_gateway_method.options_login_method.id,
      aws_api_gateway_method_response.options_login_method_response_200.id,
      aws_api_gateway_integration.options_login_integration.id,
      aws_api_gateway_integration_response.options_login_integration_response.id,
      aws_api_gateway_method.options_logout_method.id,
      aws_api_gateway_method_response.options_logout_method_response_200.id,
      aws_api_gateway_integration.options_logout_integration.id,
      aws_api_gateway_integration_response.options_logout_integration_response.id,
      aws_api_gateway_integration_response.post_login_integration_response.id,
      aws_api_gateway_integration_response.post_verify_integration_response.id,
      aws_api_gateway_integration_response.post_logout_integration_response.id,
    ]))

    //Added this to trigger a re-deployment everytime terraform script runs.
    last_modified = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Deploy in a staging environment called "dev"
resource "aws_api_gateway_stage" "password_generator_api_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.password_generator_api_gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  stage_name    = "dev"
}

# Print the invoke URL for /auth/creds on terminal
output "invoke_url" {
  value = aws_api_gateway_stage.password_generator_api_gateway_stage.invoke_url
}