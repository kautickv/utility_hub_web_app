# AWS Account Setup Instructions

Follow these steps to set up your AWS `dev` and `prod` accounts using AWS organizations.

## Step 1: Prepare AWS Accounts

1. Create an **AWS Account**.
2. Enable **AWS Organization**.
3. Add two accounts named `dev` and `prod`.

## Step 2: Set Up IAM Identity Center

1. Enable **IAM Identity Center** in your desired AWS region.
2. Create a permission set with `AdminAccess`. You can choose a different permission if you want, but ensure the user it will be assigned to has enough permission.
3. Create a user with your name and email address.
4. Assign the permission set to your user.
5. Give the user access to both the `dev` and `prod` accounts created in Step 1.

## Step 3: Configure OIDC Identity Provider in Dev Account

1. Login to `dev` Account. [Login](https://d-9067af7cb6.awsapps.com/start#/)
2. Add GitHub as an OIDC Identity provider in AWS IAM.
3. Open IAM, click on "Identity providers" and then click on "Add Provider".
4. For provider type, select "OpenID Connect".
5. For provider URL, enter `https://token.actions.githubusercontent.com`.
6. Click on "Get thumbprints".
7. For the audience, enter `sts.amazonaws.com`.

## Step 4: Create Deployment Role in Dev Account

1. Still in to the `dev` account.
2. Create a new role (e.g., `pipeline-deployment-role`) and attach the necessary permissions that Terraform needs to deploy the application. In this case, attach administrator access.
3. Navigate to the IAM service in the AWS Management Console.
4. Choose "Roles" from the sidebar and then click "Create role".
5. Select "Web Identity" for cross-account access if your dev and prod accounts are separate.
6. Choose `token.actions.githubusercontent.com` as the identity provider.
7. Audience is `sts.amazonaws.com`.
8. GitHub organization is your GitHub account name.
9. OR, you can just add the following trust policy to any role:
    ```json
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
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:<GITHUB_REPO_OWNER>/*"
        }
      }
    }
    ```

## Step 5: Setup Prod account
1. Sign in to the `prod` account.[Login](https://d-9067af7cb6.awsapps.com/start#/)
2. Repeat Step 3 and Step 4 (Using `prod` account)