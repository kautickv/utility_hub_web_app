import json
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

def verifyAuthStatus(jwtToken):
    # This function will invoke the auth lambda and verify the user auth status,
    # If user is authenticated, returns user details.
    # If user is not authenticated, return None.
    # throws an error to calling function if error occurred.

    client = boto3.client('lambda')
    try:
        response = client.invoke(
            FunctionName='password-generator-backend-lambda-auth-service',
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