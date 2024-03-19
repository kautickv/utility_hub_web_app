import os
import boto3
import json
from common.CommonUtility import CommonUtility
from common.Logger import Logger

s3_client = boto3.client('s3')
BUCKET_NAME = os.environ['S3_BUCKET_NAME']

def handlePostProjects(event, user_details):
    ## PURPOSE: This function will create a new project for a user in S3. (A folder for each user)
    ## Input: The event object from lambda, and user_details object which contains user email
    ## OUTPUT: Response object with status code and body.

    # Initialize CommonUtility Class and Logging instance
    common_utility = CommonUtility()
    logging_instance = Logger()

    try:
        # Parse the body content into a dictionary
        body_content = json.loads(event['body'])
        user_email = user_details['email']
        project_name = body_content['project_name']
        folder_name = f"{user_email}/{project_name}/"  # S3 uses the key name with a trailing slash to simulate a folder

        # Check if the project already exists
        response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=folder_name)
        if 'Contents' in response:
            # Project already exists
            return common_utility.buildResponse(400, 'Project already exists')

        # If project does not exist, create a new folder in S3
        s3_client.put_object(Bucket=BUCKET_NAME, Key=folder_name)
        return common_utility.buildResponse(200, 'Project created successfully')

    except Exception as e:
        logging_instance.log_exception(e, 'handlePostProjects')
        return common_utility.buildResponse(500, 'An error occurred while creating the project')
