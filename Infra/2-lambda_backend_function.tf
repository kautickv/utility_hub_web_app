# Install all python dependencies. Inside the back_end folder and store in a folder called layer
resource "null_resource" "pip_install" {
  triggers = {
    shell_hash = "${sha256(file("../${path.module}/back_end/requirements.txt"))}"
  }

  provisioner "local-exec" {
    command = "python3 -m pip install -r ../${path.module}/back_end/requirements.txt -t ../${path.module}/back_end/layer"
  }
}

# Create a Zip of the layer folder
data "archive_file" "layer" {
  type        = "zip"
  source_dir  = "../${path.module}/back_end/layer"
  output_file_mode = "0666"
  output_path = "../${path.module}/back_end/layer.zip"
}

# Create an object for the module zip folder and add it to bucket we created earlier

# Upload zip file to s3 bucket created earlier
resource "aws_s3_object" "password-generator-backend-lambda-function-layer-object" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "layer.zip"
  source = data.archive_file.layer.output_path

  etag = filemd5(data.archive_file.layer.output_path)
}

# Put zip folder inside a layer
resource "aws_lambda_layer_version" "layer" {
  layer_name          = "Python-layer-SOC-landing-page"
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.password-generator-backend-lambda-function-layer-object.key
  source_code_hash    = data.archive_file.layer.output_base64sha256
  compatible_runtimes = ["python3.9", "python3.8", "python3.7", "python3.6"]
}



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
  handler = "hello_world.lambda_handler"
  source_code_hash = data.archive_file.password-generator-backend-lambda-function-zip.output_base64sha256
  role = aws_iam_role.password-generator-backend-lambda-function_exec.arn
  layers = [aws_lambda_layer_version.layer.arn]
  environment {
    variables = {
      "MESSAGE" = "Terraform sends its regards"
    }
  }
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

# Upload zip file to s3 bucket created earlier
resource "aws_s3_object" "password-generator-backend-lambda-function-object" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "back_end.zip"
  source = data.archive_file.password-generator-backend-lambda-function-zip.output_path

  etag = filemd5(data.archive_file.password-generator-backend-lambda-function-zip.output_path)
}



