import boto3
import json
import requests
from utils.util import buildResponse


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
    

def get_user_info_from_google(tokens):
    # This function uses the google Oauth token to get the user profile information.

    try:
        headers = {'Authorization': 'Bearer ' + tokens["access_tokens"]}
        response = requests.get('https://www.googleapis.com/oauth2/v1/userinfo', headers=headers)
        # Parse the response
        userInfo = json.loads(response.text)
        return userInfo
    
    except Exception as e:
        print(f'Error occurred: {e}')
        return buildResponse(500, {"message": "Internal server error"})
