import json
import boto3
import gzip
import base64
import os

def verifyAuthStatus(jwtToken):
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
        print("Failed to get auth status of user")
        raise Exception ("verifyAuthStatus(): " + str(e))
    

def getAuthorizationCode(event):
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
        print("An error occurred while extracting authorization code from header" + str(e))
        raise Exception("getAuthorizationCode(): " + str(e))
    
    # Compress and encode
def compress_json(data):
    json_str = json.dumps(data)
    json_bytes = json_str.encode('utf-8')
    compressed_data = gzip.compress(json_bytes)
    encoded_data = base64.b64encode(compressed_data)
    return encoded_data.decode('utf-8')  # Convert bytes to string for storing in DynamoDB

# Decode and decompress
def decompress_json(data):
    decoded_data = base64.b64decode(data)
    decompressed_data = gzip.decompress(decoded_data)
    json_str = decompressed_data.decode('utf-8')
    return json.loads(json_str)