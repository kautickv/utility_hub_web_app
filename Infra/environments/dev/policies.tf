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
        Resource = "${module.auth_dynamodb_table.table_arn}"
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

##--------------------------------------------------------------------------------------------------------------------------------
## Policy to give read/write access to Bookmarkmanager table
## Policy to give access to Auth DynamoDB Table
resource "aws_iam_policy" "bookmarkmanager_dynamodb_policy" {
  name        = "Bookmarkmanager_DynamoDB_Policy"
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