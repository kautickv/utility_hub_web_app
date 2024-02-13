Step 1: 
- Create an AWS Account
- Enable AWS Organization
- Add two account named dev and prod

Step 2: 
- Enable IAM Identity center in your desired AWS region.
- Create a permissionset with AdminAccess. You can choose a different permission if you waant but make sure the user it will be assigned to has enough permission.
- Create a user with your name and email address.
- Assign the permission to your user.
- Give the user access to both the dev and prod account created in Step 1.

Step 3:
- Add github as an OIDC Identity provider in AWS IAM
- Open IAM, click on "Identity providers" and click on "Add Provider"
- For provider type, select "OpenID Connect"
- For provider URL, enter https://token.actions.githubusercontent.com.
- Click on "Get thumbprints"
- For audience, enter sts.amazonaws.com.

Step 4: 
 - Sign in to dev account
 - Create a new role (E.g pipeline-deplyment-role) and attach the necessary permission that terraform needs to deploy the application. In this case, I'll attach administrator access.
 - Navigate to the IAM service in the AWS Management Console.
- Choose "Roles" from the sidebar and then click "Create role".
 - Select "Web Identity" for cross-account access if your dev and prod accounts are separate.
 - Now, edit the trust relationship role 
 - Replace the trust policy with this one
 {
  "Effect": "Allow",
  "Principal": {
    "Federated": "arn:aws:iam::<AWS_ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
  },
  "Action": "sts:AssumeRoleWithWebIdentity",
  "Condition": {
    "StringEquals": {
      "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
    },
    "StringLike":{
      "token.actions.githubusercontent.com:sub": "repo:<GITHUB_REPO_OWNER>/*"
    }
  }
}


Step 5:
 - Now, we need to create a backend S3 bucket for our dev deployment
 - Go to S3, Click "Create bucket".
 - Provide a unique name for your bucket. E.g utility-hub-s3-terraform-backend
 - Select the AWS Region where you want to create the bucket
 - Create a folder inside the bucket to store the state files. E.g terraformStateFiles
 - Repeat same process for the prod account

Step 6:
- Update the respective main.tf file inside dev/ and prod/ respectively with the newly created bucket details.
