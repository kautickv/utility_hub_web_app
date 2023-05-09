Steps to set up CICD pipeline on github actions:

1. Create an IAM user on AWS
2. Create an IAM role and assign it to the user. Give the role proper access.
     - There might be two ways to go about this: One way is to create an IAM user and use API Access keys.
       Second way is to create an IAM Role and use trust relationships. (Not sure how this one works)
       Check out this link to setup credentials: https://github.com/marketplace/actions/configure-aws-credentials-for-github-actions
3. Generate secrets for IAM user and add into Git secrets.
4. Make sure we have a domain name bought and a hosted zone configured to host the front end react app
5. Request an SSL certificate and copy and paste the certificate arn into the terraform.tfvars file.




Commands:
Sync S3 buclet to local folder
    aws s3 sync --profile <profile name> <local url>  <bucket uri>

Run a cloudformatin stack template
 - This function will create a stack in cloudformation and run the template. Fails if 





Important info:

1. This is the present working directory in github actions:
    /home/runner/work/password_generator_webapp/password_generator_webapp

2. Run terraform like that. Unable to add it to environment variables
    C:\Users\kautick.vaisnavsing\Desktop\Software\Terraform\terraform.exe --version



ISSUES:

1. Everytime terraform script applies, a new layer is created irrespective if changes has been made to the layer. This will consume a lot of storage and cam cost money.

2. If bucket name is changed from the terraform.tfvars file, the terraform script failes as its trying to look for a bucket with the previous name. Think of a way to solve this.


