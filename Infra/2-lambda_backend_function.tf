# Create an IAM role to assign to lambda function
resource "aws_iam_role" "hello_lambda_exec" {
  name = "password_generator_lambda_backend_role"

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
