from utils.util import buildResponse

def lambda_handler(event, context):
    print(event)
    http_method = event['httpMethod']
    path = event['path']

    return buildResponse(200, "OK")