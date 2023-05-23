import boto3
import base64
from utils.util import buildResponse

def encrypt_to_base64(text):
    text_bytes = text.encode('utf-8')  # Convert text to bytes using UTF-8 encoding
    base64_bytes = base64.b64encode(text_bytes)  # Encode bytes to Base64
    base64_text = base64_bytes.decode('utf-8')  # Convert Base64 bytes to string
    return base64_text

def get_creds_handler(event, context):

    try:
        # Return google Client_id and redirect_uri to user
        # Create a Boto3 client for SSM
        ssm_client = boto3.client('ssm')

        # Retrieve the client_id
        response = ssm_client.get_parameter(
            Name="/password-generator/google-client/client-id",
            WithDecryption=True
        )
        # Extract the client_id
        client_id = response['Parameter']['Value']

        # Retrieve the redirect_uri
        response = ssm_client.get_parameter(
            Name="/password-generator/google-client/redirect-uris",
            WithDecryption=True
        )
        # Extract the client_id
        redirect_uri = response['Parameter']['Value']

        return buildResponse(200, {
            "client_id_base64": encrypt_to_base64(client_id),
            "redirect_uri_base64": encrypt_to_base64(redirect_uri),
        })
    except Exception as e:
        print(f"Error in get_creds. Error: {str(e)}")
        return buildResponse(500, {
            "message": "Internal Server error. Try again later"
        })