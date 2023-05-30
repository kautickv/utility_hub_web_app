import json
from utils.DynamoDBManager import DynamoDBManager
import os
import jwt
import boto3
from datetime import datetime


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
    
def is_jwt_token_valid(decoded_token):
    # This function checks if a jwt Token is still valid and has not expired.
    # Assuming the token is already decoded.

    try:
        exp = decoded_token['exp']
        if (exp):
            expiration_time = datetime.fromtimestamp(exp)
            current_time = datetime.now()
            if current_time < expiration_time:
                return True
        return False
    except Exception as e:
        print(f"Error checking if JWT token is valid: {e}")
        raise Exception ("Error checking if JWT token are valid")

def decode_jwt_token(token):
    # This function takes in an encoded function and decodes it.

    try:
        # Get Secret Key
        secret_key = getJWTSecretKey()
        decoded_token = jwt.decode(token, secret_key, algorithms=["HS256"])

        return decoded_token
    except Exception as e:
        print(f"Error Decoding token: {e}")
        raise Exception ("Error decoding JWT token")

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
        decoded_token = decode_jwt_token(jwtToken)
        
        print(decoded_token)
        #Access User Information
        userEmail = decoded_token["email"]
        print(f"User being verified: {userEmail}")

        # Check if JWT token is valid. If not, return false
        if (not is_jwt_token_valid(decoded_token)):
            return False
        
        item = userTable.get_all_attributes(userEmail)
        if (item):
            # Check if user has been logged out
            if (item["last_logout"] == ""):
                # User not logged out
                return True
            else:
                
                
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
    
