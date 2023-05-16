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


Team Communication Web Tool
The Team Communication Web Tool is a platform designed to facilitate effective and efficient communication among team members. It allows users to share text and image updates with their entire team, enabling collaboration, knowledge sharing, and transparency. The tool aims to streamline communication processes, ensuring that important information reaches the right people at the right time.

Features
User Registration and Authentication: Users can create individual accounts with unique login credentials. User authentication ensures secure access to the web tool.
Newsfeed: The primary interface for users to view and share updates. Updates are displayed in reverse chronological order, with the most recent at the top. Users can filter updates by date or specific topics.
Text Updates: Users can compose and post text updates to share information, announcements, or progress reports. Updates can be formatted using basic styling options (e.g., bold, italic, bullet points). Users can comment on and react to text updates to foster discussions and provide feedback.
Image Updates: Users can upload images to accompany their updates, enhancing visual communication. The web tool should support popular image formats and provide basic image editing capabilities (e.g., cropping, resizing).
Search and Filtering: Users can search for specific updates using keywords, authors, or dates. Advanced filtering options allow users to narrow down updates based on various criteria (e.g., team, tags, importance).
Tags and Categorization: Users can assign tags to updates to categorize them based on topics, projects, or other relevant classifications. Tags help users quickly find updates related to specific subjects.
Architecture
The project utilizes the following AWS services for its infrastructure:

AWS Lambda: The backend logic of the web tool is implemented using AWS Lambda functions. These serverless functions handle user authentication, newsfeed retrieval, text and image update posting, and other necessary functionalities.
API Gateway: AWS API Gateway creates RESTful APIs for the frontend application to interact with the Lambda functions. It handles request routing, authentication, and rate limiting.
DynamoDB: The NoSQL database provided by AWS, DynamoDB, stores user account information, updates, comments, reactions, and other relevant data. It offers fast and scalable performance for handling large volumes of data.
S3: Amazon S3 is used to host the React application and store the uploaded images. It provides high availability and durability, ensuring that the web tool remains accessible and the images are securely stored.
Deployment
The project follows a continuous integration and deployment approach. The source code is stored in this GitHub repository, and the deployment pipeline is set up using GitHub Actions. When a pull request is merged into the master branch, GitHub Actions triggers the necessary steps to deploy the updated application and infrastructure.

Infrastructure provisioning is managed using Terraform. The Terraform configuration files define and provision all the required AWS resources, including Lambda functions, API Gateway, DynamoDB tables, and S3 buckets.

Additional Features
In addition to the core features mentioned above, the project includes the following additional features:

Real-time Updates: Real-time capabilities are implemented using AWS WebSocket API to provide instant updates to users as new posts, comments, or reactions occur within the system.
Notifications: Push notifications are enabled to notify users of important updates or mentions, ensuring that users stay informed even when they are not actively using the web tool.
User Profiles: Users can create profiles with additional information such as a profile picture, bio, and contact details. This enhances personalization and promotes team bonding.
Team Management: Features to create and manage teams within the web tool are implemented. Users can join multiple teams and customize their newsfeed based on team-specific updates.
Trending Topics: Content analysis is performed on updates to display trending topics
or popular tags, helping users discover important discussions and stay updated on relevant subjects.

Mobile Application: A mobile application is developed for iOS and Android platforms, enabling users to access the team communication tool on their mobile devices, increasing accessibility and convenience.
Data Analytics: Analytics functionality is implemented to gather insights about user engagement, popular topics, and overall usage patterns. This data can help identify areas for improvement and measure the effectiveness of communication within teams.
Getting Started
To set up the project locally, follow these steps:

Clone the repository: git clone <repository-url>
Install the required dependencies: npm install
Configure the AWS credentials and other necessary environment variables.
Start the development server: npm start
For detailed instructions and additional configuration options, please refer to the documentation.

Contributing
We welcome contributions to the Team Communication Web Tool project. To contribute, please follow these guidelines:

Fork the repository and create your branch: git checkout -b my-branch
Commit your changes: git commit -am 'Add new feature'
Push to the branch: git push origin my-branch
Submit a pull request
Please ensure that your code adheres to the project's coding standards and includes appropriate tests.

License
This project is licensed under the MIT License.

Acknowledgments
We would like to thank the open-source community for their contributions and the following libraries and frameworks:

React.js
AWS SDK
Terraform
GitHub Actions
Contact
For any questions or inquiries, please contact the project team at [email protected]