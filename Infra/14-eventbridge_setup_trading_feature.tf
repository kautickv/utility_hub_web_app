# This eventbridge will be setup to trigge the trading lambda function.
resource "aws_iam_role" "eventbridge_trading_lambda_role" {
  name = "EventBridgeTradingLambdaInvokeRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "eventbridge_trading_lambda_combined_policy" {
  name        = "EventBridgeTradingLambdaCombinedPolicy"
  description = "Combined policy to allow necessary Lambda and EventBridge actions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "lambda:InvokeFunction",
        Resource  = aws_lambda_function.trading-backend-lambda-function.arn
      },
      {
        Effect    = "Allow",
        Action    = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eventbridge_trading_lambda_combined_attachment" {
  role       = aws_iam_role.eventbridge_trading_lambda_role.name
  policy_arn = aws_iam_policy.eventbridge_trading_lambda_combined_policy.arn
}

resource "aws_cloudwatch_event_rule" "trading_cron_lambda_trigger" {
  name                = "${var.app_name}TradingLambdaTrigger"
  description         = "Trigger the Lambda function"
  schedule_expression = "rate(5 minute)"
}

resource "aws_cloudwatch_event_target" "trading_cron_lambda_target" {
  rule      = aws_cloudwatch_event_rule.trading_cron_lambda_trigger.name
  target_id = "LambdaFunction"
  arn       = aws_lambda_function.trading-backend-lambda-function.arn
}


# Add permission for lambda to be involked by eventbridge
resource "aws_lambda_permission" "allow_cloudwatch_to_invoke" {
  statement_id  = "AllowTradingEventBridgeInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trading-backend-lambda-function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.trading_cron_lambda_trigger.arn
}
