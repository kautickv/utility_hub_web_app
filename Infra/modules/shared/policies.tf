## Policy to give access to Auth DynamoDB Table
resource "aws_iam_policy" "auth_dynamodb_policy" {
  name        = "${var.app_name}_Auth_DynamoDB_Policy"
  description = "Policy for Auth DynamoDB access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "dynamodb:*",
        Resource = "${module.auth_dynamodb_table.table_arn}"
      }
    ]
  })
}

##--------------------------------------------------------------------------------------------------------------------------------
# Policy to give SSM Read Access
resource "aws_iam_policy" "ssm_read_policy" {
  name        = "${var.app_name}_SSM_Policy"
  description = "Policy for SSM access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ssm:Describe*",
          "ssm:Get*",
          "ssm:List*"
        ],
        Resource = "*"
      }
    ]
  })
}
##--------------------------------------------------------------------------------------------------------------------------------
# Policy to give KMS Decrypt access
resource "aws_iam_policy" "kms_decrypt_policy" {
  name        = "${var.app_name}_KMS_Decrypt_Policy"
  description = "Policy for KMS decryption"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "kms:Decrypt",
        Resource = "*"
      }
    ]
  })
}

##--------------------------------------------------------------------------------------------------------------------------------
# Policy to give access to invoke AUTH lambda function
resource "aws_iam_policy" "invoke_auth_lambda_policy" {
  name        = "${var.app_name}_Invoke_Auth_Lambda_Policy"
  description = "This policy gives a resource access to invoke the auth lambda"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "lambda:InvokeFunction",
        Resource = "${module.auth_lamda_function.function_arn}"
      }
    ]
  })
}


##--------------------------------------------------------------------------------------------------------------------------------
## Policy to give read/write access to Bookmarkmanager table
resource "aws_iam_policy" "bookmarkmanager_dynamodb_policy" {
  name        = "${var.app_name}_Bookmarkmanager_DynamoDB_Policy"
  description = "Policy for Bookmarkmanager DynamoDB access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "dynamodb:*",
        Resource = "${module.bookmarks_dynamodb_table.table_arn}"
      }
    ]
  })
}