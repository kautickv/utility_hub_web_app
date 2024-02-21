# Create an object for the zip folder and add it to bucket we created earlier
resource "aws_s3_object" "lambda_function_layer_object" {
  bucket = var.layer_s3_bucket_id

  key    = var.key
  source = var.source

  etag = filemd5(var.source)
}

# Put zip folder inside a layer
resource "aws_lambda_layer" "layer" {
  layer_name          = var.layer_name
  s3_bucket = var.layer_s3_bucket_id
  s3_key    = aws_s3_object.lambda_function_layer_object.key
  source_code_hash    = filebase64sha256(var.source)
  compatible_runtimes = ["python3.9", "python3.8", "python3.7", "python3.6"]

}
