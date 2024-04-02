import os
import boto3
import json
from common.CommonUtility import CommonUtility
from common.Logger import Logger

s3_client = boto3.client('s3')
BUCKET_NAME = os.environ['S3_BUCKET_NAME']

def handlerPostProjectJson(event, user_details):
    ## PURPOSE: Create or delete a JSON file within an existing project for a user in S3, based on the specified action.
    ## Input: The event object from lambda, and user_details object which contains user email.
    ## OUTPUT: Response object with status code and body.

    # Initialize CommonUtility Class and Logging instance
    common_utility = CommonUtility()
    logging_instance = Logger()

    try:
        # Parse the body content into a dictionary
        body_content = json.loads(event['body'])
        action = body_content.get('action')
        project_name = body_content['project_name']
        json_object = body_content.get('json_object', {})
        json_name = json_object.get('name', '') + '.json'
        json_content = json_object.get('content', '')

        user_email = user_details['email']
        folder_prefix = f"{user_email}/{project_name}/"
        json_file_key = folder_prefix + json_name

        # Check if the project exists
        project_response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=folder_prefix)
        if 'Contents' not in project_response:
            # Project does not exist
            return common_utility.buildResponse(400, 'Project does not exist')

        if action == "create":
            # Create a new JSON file within the project folder
            s3_client.put_object(Bucket=BUCKET_NAME, Key=json_file_key, Body=json_content, ContentType='application/json')
            return common_utility.buildResponse(200, 'JSON file created successfully')

        elif action == "delete":
            # Check if the JSON file exists within the project
            json_response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=json_file_key)
            if 'Contents' not in json_response:
                # JSON file does not exist
                return common_utility.buildResponse(400, 'JSON file does not exist')
            # If JSON file exists, delete it
            s3_client.delete_object(Bucket=BUCKET_NAME, Key=json_file_key)
            return common_utility.buildResponse(200, 'JSON file deleted successfully')

        else:
            return common_utility.buildResponse(400, 'Invalid action')

    except Exception as e:
        logging_instance.log_exception(e, 'handlerPostProjectJson')
        return common_utility.buildResponse(500, 'An error occurred while processing the JSON file')
