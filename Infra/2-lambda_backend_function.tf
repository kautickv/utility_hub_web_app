# Create an IAM role to assign to lambda function
resource "aws_iam_role" "password-generator-backend-lambda-function_exec" {
  name = "password-generator-backend-lambda-function_exec"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attach basic execution policy to the above role
resource "aws_iam_role_policy_attachment" "hello_lambda_policy" {
  role       = aws_iam_role.password-generator-backend-lambda-function_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# Create the lambda fucntion which will handle backend requests
resource "aws_lambda_function" "password-generator-backend-lambda-function" {
  function_name = "password-generator-backend-lambda-function"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.password-generator-backend-lambda-function-object.key

  runtime = "python3.9"
  handler = "../back_end/hello_world.py"

  source_code_hash = data.archive_file.password-generator-backend-lambda-function-zip.output_base64sha256

  role = aws_iam_role.password-generator-backend-lambda-function_exec.arn
}

# Create a cloudwatch log group for lambda execution logs
resource "aws_cloudwatch_log_group" "password-generator-backend-lambda-function-logs" {
  name = "/aws/lambda/${aws_lambda_function.password-generator-backend-lambda-function.function_name}"

  retention_in_days = 14
}

# Zip the current backend python script
data "archive_file" "password-generator-backend-lambda-function-zip" {
  type = "zip"

  source_dir  = "../${path.module}/back_end"
  output_path = "../${path.module}/back_end.zip"
}

resource "aws_s3_object" "password-generator-backend-lambda-function-object" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "back_end.zip"
  source = data.archive_file.password-generator-backend-lambda-function-zip.output_path

  etag = filemd5(data.archive_file.password-generator-backend-lambda-function-zip.output_path)
}



