import os
import boto3
import json
from common.CommonUtility import CommonUtility
from common.Logger import Logger

s3_client = boto3.client('s3')
BUCKET_NAME = os.environ['S3_BUCKET_NAME']

def handlePostProjects(event, user_details):
    ## PURPOSE: Create or delete a project for a user in S3 based on the action specified.
    ## Input: The event object from lambda, and user_details object which contains user email.
    ## OUTPUT: Response object with status code and body.

    # Initialize CommonUtility Class and Logging instance
    common_utility = CommonUtility()
    logging_instance = Logger()

    try:
        # Parse the body content into a dictionary
        body_content = json.loads(event['body'])
        action = body_content.get('action')
        user_email = user_details['email']
        project_name = body_content['project_name']
        folder_prefix = f"{user_email}/{project_name}/"

        if action == "create":
            # Check if the project already exists
            response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=folder_prefix)
            if 'Contents' in response:
                # Project already exists
                return common_utility.buildResponse(400, 'Project already exists. Please try a different name or use existing project.')

            # If project does not exist, create a new folder in S3
            s3_client.put_object(Bucket=BUCKET_NAME, Key=folder_prefix)
            return common_utility.buildResponse(200, 'Project created successfully')

        elif action == "delete":
            # Check if the project exists
            response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=folder_prefix)
            if 'Contents' not in response:
                # Project does not exist
                return common_utility.buildResponse(400, 'Project does not exist')

            # If project exists, delete the folder and its contents
            # Note: S3 does not have a "folder" concept at the API level, so we delete all objects with the prefix
            objects_to_delete = [{'Key': obj['Key']} for obj in response['Contents']]
            s3_client.delete_objects(Bucket=BUCKET_NAME, Delete={'Objects': objects_to_delete})
            return common_utility.buildResponse(200, 'Project deleted successfully')

        else:
            return common_utility.buildResponse(400, 'Invalid action')

    except Exception as e:
        logging_instance.log_exception(e, 'handlePostProjects')
        return common_utility.buildResponse(500, 'An error occurred while processing the project')
