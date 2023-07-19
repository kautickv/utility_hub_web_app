# Create the lambda fucntion which will handle backend requests
resource "aws_lambda_function" "multitab-backend-lambda-function" {
  function_name = "${var.app_name}-backend-lambda-multitab-service"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.multitab-backend-lambda-function-object.key

  runtime = "python3.9"
  handler = "index.lambda_handler"
  source_code_hash = data.archive_file.multitab-backend-lambda-function-zip.output_base64sha256
  role = aws_iam_role.password-generator-backend-lambda-function_exec.arn
  layers = [aws_lambda_layer_version.layer.arn]
  environment {
    variables = {
      "MESSAGE" = "Terraform sends its regards",
      "USER_TABLE_NAME" = aws_dynamodb_table.sign_in_user_table.name,
      "VERIFY_AUTH_ENDPOINT" = aws_api_gateway_stage.password_generator_api_gateway_stage.invoke_url
    }
  }

  timeout = "15"
  memory_size = "128"
}

# Create a cloudwatch log group for lambda execution logs
resource "aws_cloudwatch_log_group" "password-generator-multitab-lambda-function-logs" {
  name = "/aws/lambda/${aws_lambda_function.multitab-backend-lambda-function.function_name}"

  retention_in_days = 14
}

# Zip the multitab backend python script
data "archive_file" "multitab-backend-lambda-function-zip" {
  type = "zip"

  source_dir  = "../${path.module}/back_end/multitab_service"
  output_path = "../${path.module}/multitab_service.zip"
}

# Upload zip file to s3 bucket created earlier
resource "aws_s3_object" "multitab-backend-lambda-function-object" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "multitab_service.zip"
  source = data.archive_file.multitab-backend-lambda-function-zip.output_path

  etag = filemd5(data.archive_file.multitab-backend-lambda-function-zip.output_path)
}