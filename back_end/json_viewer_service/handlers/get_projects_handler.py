import os
import boto3
import json
from common.CommonUtility import CommonUtility
from common.Logger import Logger

s3_client = boto3.client('s3')
BUCKET_NAME = os.environ['S3_BUCKET_NAME']

def handleGetProjects(event, user_details):
    # Initialize CommonUtility Class and Logging instance
    common_utility = CommonUtility()
    logging_instance = Logger()

    user_email = user_details['email']
    user_prefix = f"{user_email}/"

    try:
        # Initial check to see if the user exists (has any projects or files)
        user_existence_check = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=user_prefix, Delimiter='/', MaxKeys=1)
        if 'Contents' not in user_existence_check and 'CommonPrefixes' not in user_existence_check:
            # No projects or objects found for the user, implying the user does not exist
            return common_utility.buildResponse(400, 'User does not exist in the system')

        # Proceed with listing projects and files since the user exists
        projects_response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=user_prefix, Delimiter='/')

        projects_info = []
        for project in projects_response.get('CommonPrefixes', []):
            project_name = project['Prefix'].split('/')[-2]
            project_files = []

            files_response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=project['Prefix'])
            for file in files_response.get('Contents', []):
                file_key = file['Key']
                file_name = file_key.split('/')[-1]

                if not file_name.endswith('.json'):
                    continue

                json_file_obj = s3_client.get_object(Bucket=BUCKET_NAME, Key=file_key)
                json_file_content = json_file_obj['Body'].read().decode('utf-8')

                project_files.append({
                    'json_file_name': file_name,
                    'json_content': json_file_content
                })

            projects_info.append({
                'project_name': project_name,
                'files': project_files
            })

        return common_utility.buildResponse(200, projects_info)

    except Exception as e:
        logging_instance.log_exception(e, 'handleGetProjects')
        return common_utility.buildResponse(500, 'An error occurred while retrieving projects')
