def lambda_handler(event, context):
    
    return {
        'statusCode': 200,
        'body': {
            "Message": "Success"
        },
        'headers' : {
            'Access-Control-Allow-Origin' : '*'
        }
    }

