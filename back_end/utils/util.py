import json


def buildResponse(code, message, jwt_token=""):
    
    return{
        'statusCode': code,
        'headers':{
           'Access-Control-Allow-Origin': '*',
            'Access-Control-Expose-Headers':'x-amzn-Remapped-Authorization',
            'Authorization': 'Bearer ' + jwt_token,
            'Content-Type': 'application/json', 
        },
        'body': json.dumps({
            'message': message,
        })

    }