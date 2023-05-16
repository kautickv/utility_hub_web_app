# This terraform file will generate .env file and add it inside front_end folder as environment variable
# It will then build the react project
# Then syncs the build folder with the s3 static hosting bucket.

# Create .env and store in front_end folder. Contains API gateway invoke url, s3 website endpoint.
resource "local_file" "react_env_file" {

  filename = "../${path.module}/front_end/.env"
  content  = <<-EOF
    REACT_APP_API_GATEWAY_BASE_URL=aws_api_gateway_stage.password_generator_api_gateway_stage.invoke_url
    REACT_APP_BUCKET_HOSTING_ID = aws_s3_bucket.static_hosting_bucket_name.id
    REACT_APP_S3_WEBSITE_ENDPOINT = aws_s3_bucket_website_configuration.static_hosting_bucket_config.website_endpoint

    EOF
}

resource "null_resource" "list_directory" {
  
  #Force this block to run every time
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "cd ../${path.module}/front_end/ && ls"
  }
}
