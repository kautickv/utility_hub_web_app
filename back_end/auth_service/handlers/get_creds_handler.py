import boto3
import base64
from common.CommonUtility import CommonUtility
import json

def encrypt_to_base64(text):
    text_bytes = text.encode('utf-8')  # Convert text to bytes using UTF-8 encoding
    base64_bytes = base64.b64encode(text_bytes)  # Encode bytes to Base64
    base64_text = base64_bytes.decode('utf-8')  # Convert Base64 bytes to string
    return base64_text

def get_creds_handler(event, context):

    try:
        # Initialise Utility class
        common_utility = CommonUtility()
        # Return google Client_id and redirect_uri to user
        # Create a Boto3 client for SSM
        ssm_client = boto3.client('ssm')
        # Read configuration file
        with open('config.json') as f:
            configs = json.load(f)
        # Retrieve the client_id
        response = ssm_client.get_parameter(
            Name=configs['ssm_parameter_paths_google_login']['client_id'],
            WithDecryption=True
        )
        # Extract the client_id
        client_id = response['Parameter']['Value']

        return common_utility.buildResponse(200, {
            "client_id_base64": encrypt_to_base64(client_id),
        })
    except Exception as e:
        print(f"Error in get_creds. Error: {str(e)}")
        return common_utility.buildResponse(500, {
            "message": "Internal Server error. Try again later"
        })