import json
from utils.DynamoDBManager import DynamoDBManager
import os
import jwt
import boto3


def buildResponse(code, message, jwt_token=""):
    
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

def getJWTSecretKey():

    ssm_client = boto3.client('ssm')
    try:
            with open('config.json') as f:
                configs = json.load(f)
            response = ssm_client.get_parameter(
                    Name=configs['ssm_parameter_path_jwt_token_secret']['secret_key'],
                    WithDecryption=True
                )
            secret_key = response['Parameter']['Value']
            return secret_key
    
    except Exception as e:
        print("Failed to get JWT Secret key")
        return ""

def verifyUserLoginStatus(jwtToken):
    # This function returns true if user is authenticated.
    # Returns false if not.
    # Raises an Exception if an error occurred.

    # Get users table
    userTable = DynamoDBManager(os.getenv('USER_TABLE_NAME'))

    # Get Secret Key
    secret_key = getJWTSecretKey()

    # Verify JWT Token
    try:
        decoded_token = jwt.decode(jwtToken, secret_key, algorithms=["HS256"])
        
        print(decoded_token)
        #Access User Information
        userEmail = decoded_token["email"]
        print(f"User being verified: {userEmail}")

        item = userTable.get_all_attributes(userEmail)
        if (item):
            print(item)
        else:
            print("error")

    except jwt.ExpiredSignatureError:
        print("Token has expired.")
        return False
    except jwt.InvalidTokenError:
        print("Token is invalid.")
        return False
    except Exception as e:
        raise Exception("An error occurred during token verification.")
    
