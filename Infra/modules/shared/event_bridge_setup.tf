module "crypto_asset_lambda_trigger" {
  source              = "../../modules/event_bridge"
  lambda_arn          = module.trading_lamda_function.function_arn
  schedule_expression = "cron(0 6,18 * * ? *)"  # This triggers at 6 AM and 6 PM UTC by default
  statement_id_suffix = "crypto_asset_rule"
  event_params = {
    action = "auto"
  }
}