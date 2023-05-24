from utils.util import buildResponse
from utils.DynamoDBManager import DynamoDBManager
import boto3
import requests
import json

def get_google_auth_data():
    # This function will return the client_id, client_secret and redirect_uri from ssm parameter store
    # Create a Boto3 client for SSM
    ssm_client = boto3.client('ssm')

    # Read configuration file
    with open('config.json') as f:
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
    client_secret = response['Parameter']['Value']

    return {
        "client_id": client_id,
        "client_secret": client_secret
    }

def exchange_code_for_token(body):
    # This function exchange the code for a token with google
    google_data = get_google_auth_data()
    data = {
        "code": body["code"],
        "client_id": google_data["client_id"],
        "client_secret": google_data["client_secret"],
        "redirect_uri" : body["redirectUrl"],
        "grant_type": "authorization_code"
    }

    try:
      response = requests.post('https://oauth2.googleapis.com/token', data=data)
      # Parse the response
      tokens = json.loads(response.text)
      return tokens
    except requests.exceptions.HTTPError as err:
      print(f'Error occurred: {err}')
      return buildResponse(500, {"message": "Internal server error"})


def login_handler(body):
    # This function will receive the code provided by google.
    # It should use the code and exchange it for a token and get user information.
    token = exchange_code_for_token(body)
    print(token)
    #Add those user information in the database
    # Generate a jwt token and set it as the response header/or return in http body.
    return buildResponse(200, {"message": "OK"})