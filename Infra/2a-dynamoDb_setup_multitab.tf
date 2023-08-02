# Create the dynamoDb table. 
resource "aws_dynamodb_table" "multitab_bookmarks_table" {
  name         = "${var.app_name}_Bookmarks_table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "email"
  attribute {
    name = "email"
    type = "S"
  }
  attribute {
    name = "config_json"
    type = "S"
  }
  attribute {
    name = "last_modified"
    type = "S"
  }

  global_secondary_index {
    name               = "ConfigJsonIndex"
    hash_key           = "config_json"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }

  global_secondary_index {
    name               = "LastModified"
    hash_key           = "last_modified"
    projection_type    = "ALL"
    write_capacity     = 1
    read_capacity      = 1
  }
}