# Create an IAM role to assign to auth lambda function
resource "aws_iam_role" "auth_lambda_exec_role" {
  name = "utility-hub-auth-lambda-function_exec"

  assume_role_policy = jsonencode({
   "Version" : "2012-10-17",
   "Statement" : [
     {
       "Effect" : "Allow",
       "Principal" : {
         "Service" : "lambda.amazonaws.com"
       },
       "Action" : "sts:AssumeRole"
     },
   ]
  })
}
# Attach basic execution policy to the above role
resource "aws_iam_role_policy_attachment" "auth_role_basic_exec_attachment" {
  role       = aws_iam_role.auth_lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Attach Auth DynamoDB access policy
resource "aws_iam_policy_attachment" "auth_dynamodb_policy_attachment" {
  name       = "auth_role_DynamoDB_Policy_Attachment"
  roles      = [aws_iam_role.auth_lambda_exec_role.name]
  policy_arn = aws_iam_policy.auth_dynamodb_policy.arn
}
# Attach SSM read access policy
resource "aws_iam_policy_attachment" "auth_role_ssm_policy_attachment" {
  name       = "auth_role_ssm_Policy_Attachment"
  roles      = [aws_iam_role.auth_lambda_exec_role.name]
  policy_arn = aws_iam_policy.ssm_read_policy.arn
}
# Attach KMS decrypt access policy
resource "aws_iam_policy_attachment" "auth_role_kms_decrypt_policy_attachment" {
  name       = "auth_role_kms_decrypt_Policy_Attachment"
  roles      = [aws_iam_role.auth_lambda_exec_role.name]
  policy_arn = aws_iam_policy.kms_decrypt_policy.arn
}
