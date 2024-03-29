import boto3
import json
import requests
import os
import jwt
from datetime import datetime, timedelta
from utils.util import getJWTSecretKey, decode_jwt_token
from utils.DynamoDBManager import DynamoDBManager
from common.Logger import Logger

class GoogleAuth:

    def __init__(self):
        self.__ssm_client = boto3.client('ssm')
        self.__access_token = None
        self.__refresh_token = None
        self.__user_name = None
        self.__jwt_token = None
        self.__user_email = None
        self.__jwttoken_expiration_duration = 3   # JWT token will expire in 3 hours

        # Create instance of signin dynamo table
        self.__signInTableDb = DynamoDBManager(os.getenv('USER_TABLE_NAME'))
        #Initialise Logging instance
        self.logging_instance = Logger()


    def get_google_auth_data(self):

        try:
            with open('config.json') as f:
                configs = json.load(f)
            response = self.__ssm_client.get_parameter(
                    Name=configs['ssm_parameter_paths_google_login']['client_id'],
                    WithDecryption=True
                )
            client_id = response['Parameter']['Value']

            response = self.__ssm_client.get_parameter(
                    Name=configs['ssm_parameter_paths_google_login']['client_secret'],
                    WithDecryption=True
                )
            client_secret = response['Parameter']['Value']

            return {
                "client_id": client_id,
                "client_secret": client_secret
            }
        except Exception as e:
            self.logging_instance.log_exception(e, 'get_google_auth_data')
            raise  # Throw exception


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
        except Exception as e:
            self.logging_instance.log_exception(e, 'exchange_code_for_token')
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
            self.logging_instance.log_exception(e, 'get_user_info_from_google')
            return False

    def generate_jwt_token(self, expInHours):
        # This function will generate and return a jwt token for this user
        payload = {
            "email": self.__user_email,
            "username": self.__user_name,
            "exp":datetime.utcnow() + timedelta(hours=expInHours)  # Expiration time
        }

        # Get secret Key from SSM parameter store
        try:
            
            secret_key = getJWTSecretKey()

            # Generate the JWT token
            token = jwt.encode(payload, secret_key, algorithm='HS256')
            self.__jwt_token = token

            return token
        except Exception as e:
            self.logging_instance.log_exception(e, 'generate_jwt_token')
            raise # Throw exception

    def add_user_info_in_db(self):
        # This function will add safe the user information in the user database.
        # If user already exists, it will override it with the latest information.

        try:
            userData = {
                "email": self.__user_email,
                "first_name": self.__user_name.split(' ')[0],
                "last_name": self.__user_name.split(' ')[1],
                "jwt_token": self.generate_jwt_token(self.__jwttoken_expiration_duration), # Token will be valid for 3 hours
                "access_token": self.__access_token,
                "refresh_token": self.__refresh_token,
                "last_logout": " ",
                "last_login": str(datetime.utcnow()),
                "login_status": 1
            }

            # Add item in database
            if (not self.__signInTableDb.add_item(userData)):
                raise Exception(f"(add_user_info_in_db): User Could not be added to database.")
            

            return True
        

        except Exception as e:
            self.logging_instance.log_exception(e, 'add_user_info_in_db')
            return False

    def logoutUser(self, token):
        # This function will take in a user email and log user out.
        # It will update the login_status field on dynamo to 0 and last_logout to current time.

        try:
            # Decode token
            decoded_jwt_token = decode_jwt_token(token)
            if (decode_jwt_token == 401):
                return False  # Already logged out
            self.__signInTableDb.update_user_data(decoded_jwt_token["email"], login_status=0, last_logout=str(datetime.utcnow()))
            return True
        except Exception as e:
            self.logging_instance.log_exception(e, 'logoutUser')
            return False

    # Getter functions
    def get_user_name(self):
        return self.__user_name
    
    def get_user_email(self):
        return self.__user_email
    
    def get_jwt_token(self):
        return self.__jwt_token
