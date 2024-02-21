## Policy to give access to Auth DynamoDB Table
resource "aws_iam_policy" "auth_dynamodb_policy" {
  name        = "Auth_DynamoDB_Policy"
  description = "Policy for Auth DynamoDB access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "dynamodb:*",
        Resource = "${aws_dynamodb_table.sign_in_user_table.arn}"
      }
    ]
  })
}

##--------------------------------------------------------------------------------------------------------------------------------
# Policy to give SSM Read Access
resource "aws_iam_policy" "ssm_read_policy" {
  name        = "SSM_Policy"
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
  name        = "KMS_Decrypt_Policy"
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


