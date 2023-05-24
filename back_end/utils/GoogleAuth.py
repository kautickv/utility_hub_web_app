import boto3
import json
import requests
from utils.util import buildResponse

class GoogleAuth:

    def __init__(self):
        self.__ssm_client = boto3.client('ssm')
        self.__access_token = None
        self.__refresh_token = None
        self.__user_name = None
        self.__user_email = None

    def get_google_auth_data(self):

        try:
            with open('config.json') as f:
                configs = json.load(f)
            response = self.__ssm_client.get_parameter(
                    Name=configs['ssm_parameter_paths']['client_id'],
                    WithDecryption=True
                )
            client_id = response['Parameter']['Value']

            response = self.__ssm_client.get_parameter(
                    Name=configs['ssm_parameter_paths']['client_secret'],
                    WithDecryption=True
                )
            client_secret = response['Parameter']['Value']

            return {
                "client_id": client_id,
                "client_secret": client_secret
            }
        except Exception as e:
            print(f'Error(get_google_auth_data): {e}')

    def exchange_code_for_token(self, body):
        google_data = self.get_google_auth_data()
        data = {
            "code": body["code"],
            "client_id": google_data["client_id"],
            "client_secret": google_data["client_secret"],
            "redirect_uri" : body["redirectUrl"],
            "grant_type": "authorization_code"
        }

        try:
            response = requests.post('https://oauth2.googleapis.com/token', data=data)
            tokens = json.loads(response.text)
            ## Assign access_token and refresh_token variables
            self.__access_token = tokens["access_token"]
            self.__refresh_token = tokens["refresh_token"]

            return True
        except requests.exceptions.HTTPError as err:
            print(f'Error(exchange_code_for_token): {err}')
            return False

    def get_user_info_from_google(self):
        try:
            headers = {'Authorization': 'Bearer ' + self.__access_token}
            response = requests.get('https://www.googleapis.com/oauth2/v1/userinfo', headers=headers)
            userInfo = json.loads(response.text)
            self.__user_name = userInfo["name"]
            self.__user_email = userInfo["email"]

            return True

        except Exception as e:
            print(f'Error(get_user_info_from_google): {e}')
            return False
        
    # Getter functions
    def get_user_name(self):
        return self.__user_name
    
    def get_user_email(self):
        return self.__user_email
