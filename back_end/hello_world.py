import requests

def lambda_handler(event, context):
    name = "fdhdfhdfh"
    print(f'Hello, {name}!')
    return {
        'statusCode': 200,
        'body': f'Hello, {name}!'
    }
