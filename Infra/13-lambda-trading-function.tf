# Create an IAM role for trading lambda
resource "aws_iam_role" "lambda_trading_exec_role" {
  name = "${var.app_name}-lambda-trading-exec-role"

  assume_role_policy = jsonencode({
   "Version" : "2012-10-17",
   "Statement" : [
     {
       "Effect" : "Allow",
       "Principal" : {
         "Service" : "lambda.amazonaws.com"
       },
       "Action" : "sts:AssumeRole"
     }
   ]
  })
}

# Attach the basic AWSLambdaBasicExecutionRole policy to trading lambda role
resource "aws_iam_role_policy_attachment" "lambda_trading_basic_execution" {
  role       = aws_iam_role.lambda_trading_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create a custom IAM policy that gives trading lambda function to invoke auth lambda function.
resource "aws_iam_policy" "lambda_trading_invoke_lambda_auth" {
  name        = "lambdaTradingInvokeLambdaAuth"
  description = "Allows Lambda trading lambda to invoke Lambda auth"
  policy      = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
           "Effect" : "Allow",
           "Action" : [
             "dynamodb:*"
            ],
           "Resource" : [
             "${aws_dynamodb_table.multitab_bookmarks_table.arn}"
           ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
             "ssm:Describe*",
              "ssm:Get*",
              "ssm:List*"
            ],
          "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action" : [
            "kms:Decrypt"
          ],
          "Resource":"*"
        },
        {
          "Effect": "Allow",
          "Action":"lambda:InvokeFunction",
          "Resource": "${aws_lambda_function.password-generator-backend-lambda-function.arn}"
        }
      ]
   })
}

resource "aws_iam_role_policy_attachment" "lambda_trading_invoke_lambda_auth_attachment" {
  role       = aws_iam_role.lambda_trading_exec_role.name
  policy_arn = aws_iam_policy.lambda_trading_invoke_lambda_auth.arn
}

# Create the lambda fucntion which will handle backend requests
resource "aws_lambda_function" "trading-backend-lambda-function" {
  function_name = "${var.app_name}-backend-lambda-trading-service"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.trading-backend-lambda-function-object.key

  runtime = "python3.9"
  handler = "index.lambda_handler"
  source_code_hash = data.archive_file.trading_lambda_permission-backend-lambda-function-zip.output_base64sha256
  role = aws_iam_role.lambda_trading_exec_role.arn
  layers = [aws_lambda_layer_version.layer.arn]
  environment {
    variables = {
      "MESSAGE" = "Terraform sends its regards",
      "AUTH_SERVICE_LAMBDA_NAME" = aws_lambda_function.password-generator-backend-lambda-function.function_name
    }
  }

  timeout = "15"
  memory_size = "128"
}


# Create a cloudwatch log group for lambda execution logs
resource "aws_cloudwatch_log_group" "trading-lambda-function-logs" {
  name = "/aws/lambda/${aws_lambda_function.trading-backend-lambda-function.function_name}"

  retention_in_days = 14
}

# Zip the multitab backend python script
data "archive_file" "trading-backend-lambda-function-zip" {
  type = "zip"

  source_dir  = "../${path.module}/back_end/trading_service"
  output_path = "../${path.module}/trading_service.zip"
}

# Upload zip file to s3 bucket created earlier
resource "aws_s3_object" "trading-backend-lambda-function-object" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "trading_service.zip"
  source = data.archive_file.trading-backend-lambda-function-zip.output_path

  etag = filemd5(data.archive_file.trading-backend-lambda-function-zip.output_path)
}