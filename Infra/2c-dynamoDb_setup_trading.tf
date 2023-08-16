# Create the dynamoDb table. 
resource "aws_dynamodb_table" "crypto_trading_table" {
  name         = "${var.app_name}_crypto_trading_table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "key"
  attribute {
    name = "key"
    type = "S"
  }
  attribute {
    name = "crypto_ticker"
    type = "S"
  }
  attribute {
    name = "ema_signal"
    type = "S"
  }
  attribute {
    name = "rsi_signal"
    type = "S"
  }
  attribute {
    name = "volume_signal"
    type = "S"
  }
  attribute {
    name = "bollinger_signal"
    type = "S"
  }
   attribute {
    name = "last_fetch"
    type = "S"
  }

  global_secondary_index {
    name               = "Key_index"
    hash_key           = "key"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }

  global_secondary_index {
    name               = "CryptoTicker"
    hash_key           = "crypto_ticker"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }

  global_secondary_index {
    name               = "EMASignal"
    hash_key           = "ema_signal"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }

  global_secondary_index {
    name               = "RSISignal"
    hash_key           = "rsi_signal"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }

  global_secondary_index {
    name               = "VolumeSignal"
    hash_key           = "volume_signal"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }

  global_secondary_index {
    name               = "BollingerSignal"
    hash_key           = "bollinger_signal"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }
  global_secondary_index {
    name               = "LastFetch"
    hash_key           = "last_fetch"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }
}

