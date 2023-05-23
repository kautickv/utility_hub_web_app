from utils.util import buildResponse
from utils.util import DynamoDBManager
import boto3
import requests
import json

def get_google_auth_data():
    # This function will return the client_id, client_secret and redirect_uri from ssm parameter store
    # Create a Boto3 client for SSM
    ssm_client = boto3.client('ssm')

    # Read configuration file
    with open('../config.json') as f:
        configs = json.load(f)
    # Retrieve the client_id
    response = ssm_client.get_parameter(
            Name=configs['ssm_parameter_paths']['client_id'],
            WithDecryption=True
        )
    client_id = response['Parameter']['Value']

    # Retrieve the client_secret
    response = ssm_client.get_parameter(
            Name=configs['ssm_parameter_paths']['client_secret'],
            WithDecryption=True
        )

def login_handler(event, context):
    # This function will receive the code provided by google.
    # It should use the code and exchange it for a token and get user information.
    #Add those user information in the database
    # Generate a jwt token and set it as the response header/or return in http body.
    return buildResponse(200, {"message": "OK"})