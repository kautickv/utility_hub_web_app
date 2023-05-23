import boto3
from utils.util import buildResponse

def get_creds_handler(event, context):

    try:
        # Return google Client_id and redirect_uri to user
        # Create a Boto3 client for SSM
        ssm_client = boto3.client('ssm')

        # Retrieve the client_id
        response = ssm_client.get_parameter(
            Name="password_generator/google_client/client_id",
            WithDecryption=True
        )
        # Extract the client_id
        client_id = response['Parameter']['Value']

        # Retrieve the redirect_uri
        response = ssm_client.get_parameter(
            Name="password_generator/google_client/redirect_uri",
            WithDecryption=True
        )
        # Extract the client_id
        redirect_uri = response['Parameter']['Value']

        return buildResponse(200, {
            client_id: client_id,
            redirect_uri: redirect_uri,
        })
    except Exception as e:
        print(f"Error in get_creds. Error: {str(e)}")
        return buildResponse(500, {
            "message": "Internal Server error. Try again later"
        })