import requests

def lambda_handler(event, context):
    print(event)
    response = requests.get('https://google.com')
    return {
        'statusCode': response.status_code,
        'body': response.text
    }
