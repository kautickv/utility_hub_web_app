# Create a REST API gateway in AWS
resource "aws_api_gateway_rest_api" "password_generator_api_gateway" {
  name        = "${var.app_name}_api_gateway"
  description = "REST API gateway for ${var.app_name} app."
}

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
  depends_on = [aws_api_gateway_method_response.options_home_method_response_200]
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
  function_name   = aws_lambda_function.password-generator-backend-lambda-function.function_name
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
  uri                     = aws_lambda_function.password-generator-backend-lambda-function.invoke_arn
}

# Create a resource called "auth" inside the API gateway
resource "aws_api_gateway_resource" "password_generator_api_gateway_auth_resource" {
  parent_id   = aws_api_gateway_rest_api.password_generator_api_gateway.root_resource_id
  path_part   = "auth"
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

# Add Options method for auth resource
resource "aws_api_gateway_method" "options_auth_method" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_auth_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_auth_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_auth_resource.id
  http_method   = aws_api_gateway_method.options_auth_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options_auth_method]
}

resource "aws_api_gateway_integration" "options_auth_integration" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_auth_resource.id
  http_method   = aws_api_gateway_method.options_auth_method.http_method
  type          = "MOCK"
  depends_on    = [aws_api_gateway_method.options_auth_method]
}

resource "aws_api_gateway_integration_response" "options_auth_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_auth_resource.id
  http_method   = aws_api_gateway_method.options_auth_method.http_method
  status_code   = aws_api_gateway_method_response.options_auth_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.options_auth_method_response_200]
}

# Create a resource called "creds" inside the "auth" resource
resource "aws_api_gateway_resource" "password_generator_api_gateway_creds_resource" {
  parent_id   = aws_api_gateway_resource.password_generator_api_gateway_auth_resource.id
  path_part   = "creds"
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

# Add Options method for creds resource
resource "aws_api_gateway_method" "options_creds_method" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_creds_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# Add a GET method to "creds" resource ("/auth/creds")
resource "aws_api_gateway_method" "get_creds_method" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_creds_resource.id
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

resource "aws_api_gateway_method_response" "get_creds_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_creds_resource.id
  http_method   = aws_api_gateway_method.get_creds_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
  depends_on = [aws_api_gateway_method.get_creds_method]
}

# Integrate the GET method for "creds" with our backend lambda function created earlier
resource "aws_api_gateway_integration" "get_creds_integration" {
  http_method             = aws_api_gateway_method.get_creds_method.http_method
  resource_id             = aws_api_gateway_resource.password_generator_api_gateway_creds_resource.id
  rest_api_id             = aws_api_gateway_rest_api.password_generator_api_gateway.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.password-generator-backend-lambda-function.invoke_arn
}

resource "aws_api_gateway_method_response" "options_creds_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_creds_resource.id
  http_method   = aws_api_gateway_method.options_creds_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options_creds_method]
}

resource "aws_api_gateway_integration" "options_creds_integration" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_creds_resource.id
  http_method   = aws_api_gateway_method.options_creds_method.http_method
  type          = "MOCK"
  depends_on    = [aws_api_gateway_method.options_creds_method]
}

resource "aws_api_gateway_integration_response" "options_creds_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_creds_resource.id
  http_method   = aws_api_gateway_method.options_creds_method.http_method
  status_code   = aws_api_gateway_method_response.options_creds_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.options_creds_method_response_200]
}

# Add a resource called "verify" inside the "auth" resource
resource "aws_api_gateway_resource" "password_generator_api_gateway_verify_resource" {
  parent_id   = aws_api_gateway_resource.password_generator_api_gateway_auth_resource.id
  path_part   = "verify"
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

# Add a POST method to "verify" resource ("/auth/verify")
resource "aws_api_gateway_method" "post_verify_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_verify_resource.id
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

resource "aws_api_gateway_method_response" "post_verify_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_verify_resource.id
  http_method   = aws_api_gateway_method.post_verify_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
  depends_on = [aws_api_gateway_method.post_verify_method]
}

# Integrate the POST method for "verify" with our backend lambda function created earlier
resource "aws_api_gateway_integration" "post_verify_integration" {
  http_method             = aws_api_gateway_method.post_verify_method.http_method
  resource_id             = aws_api_gateway_resource.password_generator_api_gateway_verify_resource.id
  rest_api_id             = aws_api_gateway_rest_api.password_generator_api_gateway.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.password-generator-backend-lambda-function.invoke_arn
}

# Configure CORS for the POST integration on "verify" resource
resource "aws_api_gateway_integration_response" "post_verify_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_verify_resource.id
  http_method   = aws_api_gateway_method.post_verify_method.http_method
  status_code   = aws_api_gateway_method_response.post_verify_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.post_verify_method_response_200]
}

# Add Options method for verify resource
resource "aws_api_gateway_method" "options_verify_method" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_verify_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_verify_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_verify_resource.id
  http_method   = aws_api_gateway_method.options_verify_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options_verify_method]
}

resource "aws_api_gateway_integration" "options_verify_integration" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_verify_resource.id
  http_method   = aws_api_gateway_method.options_verify_method.http_method
  type          = "MOCK"
   request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  depends_on    = [aws_api_gateway_method.options_verify_method]
}

resource "aws_api_gateway_integration_response" "options_verify_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_verify_resource.id
  http_method   = aws_api_gateway_method.options_verify_method.http_method
  status_code   = aws_api_gateway_method_response.options_verify_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.options_verify_method_response_200]
}

# Add a resource called "login" inside the "auth" resource
resource "aws_api_gateway_resource" "password_generator_api_gateway_login_resource" {
  parent_id   = aws_api_gateway_resource.password_generator_api_gateway_auth_resource.id
  path_part   = "login"
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

# Add a POST method to "login" resource ("/auth/login")
resource "aws_api_gateway_method" "post_login_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_login_resource.id
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

resource "aws_api_gateway_method_response" "post_login_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_login_resource.id
  http_method   = aws_api_gateway_method.post_login_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
  depends_on = [aws_api_gateway_method.post_login_method]
}

# Integrate the POST method for "login" with our backend lambda function created earlier
resource "aws_api_gateway_integration" "post_login_integration" {
  http_method             = aws_api_gateway_method.post_login_method.http_method
  resource_id             = aws_api_gateway_resource.password_generator_api_gateway_login_resource.id
  rest_api_id             = aws_api_gateway_rest_api.password_generator_api_gateway.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.password-generator-backend-lambda-function.invoke_arn
}

# Configure CORS for the POST integration on "login" resource
resource "aws_api_gateway_integration_response" "post_login_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_login_resource.id
  http_method   = aws_api_gateway_method.post_login_method.http_method
  status_code   = aws_api_gateway_method_response.post_login_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.post_login_method_response_200]
}

# Add Options method for login resource
resource "aws_api_gateway_method" "options_login_method" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_login_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_login_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_login_resource.id
  http_method   = aws_api_gateway_method.options_login_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options_login_method]
}

resource "aws_api_gateway_integration" "options_login_integration" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_login_resource.id
  http_method   = aws_api_gateway_method.options_login_method.http_method
  type          = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  depends_on    = [aws_api_gateway_method.options_login_method]
}

resource "aws_api_gateway_integration_response" "options_login_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_login_resource.id
  http_method   = aws_api_gateway_method.options_login_method.http_method
  status_code   = aws_api_gateway_method_response.options_login_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.options_login_method_response_200]
}

# Add a resource called "logout" inside the "auth" resource
resource "aws_api_gateway_resource" "password_generator_api_gateway_logout_resource" {
  parent_id   = aws_api_gateway_resource.password_generator_api_gateway_auth_resource.id
  path_part   = "logout"
  rest_api_id = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

# Add a POST method to "logout" resource ("/auth/logout")
resource "aws_api_gateway_method" "post_logout_method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_logout_resource.id
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
}

resource "aws_api_gateway_method_response" "post_logout_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_logout_resource.id
  http_method   = aws_api_gateway_method.post_logout_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
  depends_on = [aws_api_gateway_method.post_logout_method]
}

# Integrate the POST method for "logout" with our backend lambda function created earlier
resource "aws_api_gateway_integration" "post_logout_integration" {
  http_method             = aws_api_gateway_method.post_logout_method.http_method
  resource_id             = aws_api_gateway_resource.password_generator_api_gateway_logout_resource.id
  rest_api_id             = aws_api_gateway_rest_api.password_generator_api_gateway.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.password-generator-backend-lambda-function.invoke_arn
}

# Configure CORS for the POST integration on "logout" resource
resource "aws_api_gateway_integration_response" "post_logout_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_logout_resource.id
  http_method   = aws_api_gateway_method.post_logout_method.http_method
  status_code   = aws_api_gateway_method_response.post_logout_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.post_logout_method_response_200]
}


# Add Options method for logout resource
resource "aws_api_gateway_method" "options_logout_method" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_logout_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_logout_method_response_200" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_logout_resource.id
  http_method   = aws_api_gateway_method.options_logout_method.http_method
  status_code   = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options_logout_method]
}

resource "aws_api_gateway_integration" "options_logout_integration" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_logout_resource.id
  http_method   = aws_api_gateway_method.options_logout_method.http_method
  type          = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  depends_on    = [aws_api_gateway_method.options_logout_method]
}

resource "aws_api_gateway_integration_response" "options_logout_integration_response" {
  rest_api_id   = aws_api_gateway_rest_api.password_generator_api_gateway.id
  resource_id   = aws_api_gateway_resource.password_generator_api_gateway_logout_resource.id
  http_method   = aws_api_gateway_method.options_logout_method.http_method
  status_code   = aws_api_gateway_method_response.options_logout_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.options_logout_method_response_200]
}

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
      aws_api_gateway_rest_api.password_generator_api_gateway.root_resource_id,  # Include root resource ID
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
    ]))
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
