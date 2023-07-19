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
    # If user is authenticated, returns true.
    # If user is not authenticated, return false.
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
        if 'FunctionError' in response:
            error_response = json.load(response['Payload'])
            print(f"Error type: {error_response['errorType']}")
            print(f"Error message: {error_response['errorMessage']}")
            raise Exception("Auth lambda encountered an error.")
        
        elif response['statusCode'] is 200:
            return True
        else:
            return False
        
    except Exception as e:
        print("Failed to get auth status of user")
        raise Exception ("verifyAuthStatus(): " + str(e))