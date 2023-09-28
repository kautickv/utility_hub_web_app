# Create an IAM role for Home lambda
resource "aws_iam_role" "lambda_home_exec_role" {
  name = "${var.app_name}-lambda-home-exec-role"

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

# Attach the basic AWSLambdaBasicExecutionRole policy to multitab lambda role
resource "aws_iam_role_policy_attachment" "lambda_home_basic_execution" {
  role       = aws_iam_role.lambda_home_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create a custom IAM policy that gives multitab lambda function to invoke auth lambda function.
resource "aws_iam_policy" "lambda_home_invoke_lambda_auth" {
  name        = "lambdaHomeInvokeLambdaAuth"
  description = "Allows Lambda home to invoke Lambda auth"
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
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface"
            ],
            "Resource": "*"
        }
      ]
   })
}

resource "aws_iam_role_policy_attachment" "lambda_home_invoke_lambda_auth_attachment" {
  role       = aws_iam_role.lambda_home_exec_role.name
  policy_arn = aws_iam_policy.lambda_home_invoke_lambda_auth.arn
}

# Create the lambda fucntion which will handle backend requests
resource "aws_lambda_function" "home-backend-lambda-function" {
  function_name = "${var.app_name}-backend-lambda-home-service"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.home-backend-lambda-function-object.key

  runtime = "python3.9"
  handler = "index.lambda_handler"
  source_code_hash = data.archive_file.home-backend-lambda-function-zip.output_base64sha256
  role = aws_iam_role.lambda_home_exec_role.arn
  layers = [aws_lambda_layer_version.layer.arn]
  environment {
    variables = {
      "MESSAGE" = "Terraform sends its regards",
      "BOOKMARKS_TABLE_NAME" = aws_dynamodb_table.multitab_bookmarks_table.name,
      "AUTH_SERVICE_LAMBDA_NAME" = aws_lambda_function.password-generator-backend-lambda-function.function_name
    }
  }

  vpc_config {
    subnet_ids = [
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id,
      aws_subnet.private_subnet_3.id
    ]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  timeout = "180"
  memory_size = "128"
}


# Create a cloudwatch log group for lambda execution logs
resource "aws_cloudwatch_log_group" "home-lambda-function-logs" {
  name = "/aws/lambda/${aws_lambda_function.home-backend-lambda-function.function_name}"

  retention_in_days = 14
}

# Zip the multitab backend python script
data "archive_file" "home-backend-lambda-function-zip" {
  type = "zip"

  source_dir  = "../${path.module}/back_end/home_service"
  output_path = "../${path.module}/home_service.zip"
}

# Upload zip file to s3 bucket created earlier
resource "aws_s3_object" "home-backend-lambda-function-object" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "home_service.zip"
  source = data.archive_file.home-backend-lambda-function-zip.output_path

  etag = filemd5(data.archive_file.home-backend-lambda-function-zip.output_path)
}