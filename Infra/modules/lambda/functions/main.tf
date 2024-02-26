# Create the lambda fucntion which will handle backend requests and it's associated
# cloudwatch for logging.
resource "aws_lambda_function" "lamda_function" {
  function_name = var.function_name

  s3_bucket = var.s3_bucket_id
  s3_key    = var.s3_bucket_key

  runtime = "python3.9"
  handler = var.handler_name
  source_code_hash = var.source_code_hash
  role = var.role_arn
  layers = var.layers_arn
  environment {
    variables = var.environment_variables
  }

  timeout = var.timeout
  memory_size = var.memory_size
}

# Create a cloudwatch log group for lambda execution logs
resource "aws_cloudwatch_log_group" "lamda_function-logs" {
  name = "/aws/lambda/${aws_lambda_function.lamda_function.function_name}"

  retention_in_days = 14
}
