###
# PURPOSE: This class will contain the implementation of helper functions which will
#          be shared by all the lambdas.

import json

class CommonUtility:

    def __init__(self):
        pass

    
    def buildResponse(code, message, jwt_token=""):
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