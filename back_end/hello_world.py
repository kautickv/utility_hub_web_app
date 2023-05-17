def lambda_handler(event, context):
    
    return {
        'statusCode': 200,
        'body': 'Item added to DynamoDB table.',
        'headers' : {
            'Access-Control-Allow-Origin' : '*'
        }
    }

