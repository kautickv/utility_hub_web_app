# Create a single layer which will be attached to all lambdas
module "lambda_python_layer" {
    source = "../../modules/lambda/layers"

    layer_s3_bucket_id = module.lambda_zip_s3_bucket.bucket_id
    key = "layer.zip"
    file_source = "${path.module}/layer.zip"
    layer_name = "Python-layer-Utility_Hub"
}