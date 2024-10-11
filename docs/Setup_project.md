# Project Setup Instructions

Follow these steps to prepare for deployment with Terraform.


## Step 1: Create S3 Backend for Terraform

1. Now, we need to create a backend S3 bucket for our dev deployment.
2. Using `dev` account, Go to S3, Click "Create bucket".
3. Provide a unique name for your bucket. E.g., `utility-hub-s3-terraform-backend`.
4. Select the AWS Region where you want to create the bucket.
5. Repeat the same process for the `prod` account.

## Step 2: Update Terraform Configuration

1. **Main Terraform Files**: Update the respective `main.tf` files within the `dev/` and `prod/` directories, adding the details of the newly created S3 buckets.

2. **Development Configuration**: Modify the `deploy_dev.tfvars` file to include application-specific configurations:
   - **App Name**: Specify the name of your application (e.g., `Test-app`).
   - **Domain Name**: Enter the domain name used to access the development version of the app.
   - **Bucket Name**: The S3 bucket name designated for storing React files.
   - **Hosted Zone ID**: The Hosted Zone Id for DNS configuration (ensure domain ownership).
   - **AWS Default Region**: The default AWS region for deploying resources.
   - **DNS Account Region**: Specify the AWS region of the hosted zone, which can be in a different AWS account if necessary.
   - **use_vpc**: This is a boolean toggle which will deploy all backend resources inside a custom VPC if set to true or will deploy in default AWS VPC if set to false.If set to true, it will create all the required resources to operate a VPC like subnets, reoute tables, internet gateways, NAT gateways, VPC endpints and all associated security groups and IAM policies.

3. **Production Configuration**: Adapt the `deploy_prod.tfvars` file with analogous details tailored for the production environment, following the same structure as the development configuration.

## Step 3: Update IAM Role for Deployment


1. **Deployment Configurations**: Edit the `deployment_config.json` file to include the IAM Role ARN (Amazon Resource Name) for both the default account and the DNS account, applicable to `dev` and `prod` environments. This step is crucial for granting the necessary permissions for deployment activities.

