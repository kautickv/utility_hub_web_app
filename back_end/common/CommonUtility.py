###
# PURPOSE: This class will contain the implementation of helper functions which will
#          be shared by all the lambdas.

import json
import boto3
import os
from common.Logger import Logger

class CommonUtility:

    def __init__(self):
        #Initialise Logging instance
        self.logging_instance = Logger()

    
    def buildResponse(self, code, message, jwt_token=""):
    ###
    # PURPOSE: This function will return json object having the statusCode, headers and body of
    #          a response onject.
    # INPUT: statuscode as integer, message to pass as body and jwtToken (optional)
    # OUTPUT: The json object.
        return{
            'statusCode': code,
            'headers':{
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Expose-Headers':'x-amzn-Remapped-Authorization',
                'Authorization': 'Bearer ' + jwt_token,
                'Content-Type': 'application/json', 
            },
            'body': json.dumps(message)
        }
    
    def verifyAuthStatus(self, jwtToken):
        # This function will invoke the auth lambda and verify the user auth status,
        # If user is authenticated, returns user details.
        # If user is not authenticated, return None.
        # throws an error to calling function if error occurred.

        client = boto3.client('lambda')
        try:
            response = client.invoke(
                FunctionName=os.environ['AUTH_SERVICE_LAMBDA_NAME'],
                InvocationType='RequestResponse',
                Payload=json.dumps({
                    'httpMethod': 'POST',
                    'path': '/auth/verify',
                    'Authorization': 'Bearer ' + jwtToken
                    })
            )

            response_payload = json.loads(response['Payload'].read().decode('utf-8'))
            if 'FunctionError' in response:
                error_response = json.load(response['Payload'])
                print(f"Error type: {error_response['errorType']}")
                print(f"Error message: {error_response['errorMessage']}")
                raise Exception("Auth lambda encountered an error.")
            
            elif response_payload['statusCode'] == 200:
                
                return json.loads(response_payload['body'])['token_details']
            else:
                return None
            
        except Exception as e:
            self.logging_instance.log_exception(e, 'verifyAuthStatus')
            raise
    

    def getAuthorizationCode(self, event):
        # This function will check if the header has an authorization code.
        # If code is present, it returns the code. Otherwise returns None.

        # Extract token from headers
        token = None
        try:
            if "headers" in event and "Authorization" in event["headers"]:
                authorization_header = event["headers"]["Authorization"]
                if authorization_header.startswith("Bearer "):
                    split_header = authorization_header.split()
                    if len(split_header) > 1:
                        token = split_header[1].strip()
                    else:
                        token = None
                else:
                    token = None
            else:
                token = None
        
            return token
            
        except Exception as e:
            self.logging_instance.log_exception(e, 'getAuthorizationCode')
            raise