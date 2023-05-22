import json

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

