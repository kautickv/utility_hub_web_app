import json

def lambda_handler(event, context):
    
    print(event["resource"]) # Or event["path"] == "/auth/creds"
    return {
        'statusCode': 200,
        'body': json.dumps({
            "Message": "Success"
        }),
        'headers' : {
            'Access-Control-Allow-Origin' : '*'
        }
    }

