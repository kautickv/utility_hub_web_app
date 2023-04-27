def lambda_handler(event, context):
    print(event)
    print("Hello World")
    return {
        'statusCode': 200,
        'body': 'Hello World!'
    }
