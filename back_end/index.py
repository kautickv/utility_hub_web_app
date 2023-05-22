import json
from utils.util import buildResponse

def lambda_handler(event, context):
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            "Message": "Success"
        }),
        'headers' : {
            'Access-Control-Allow-Origin' : '*'
        }
    }

