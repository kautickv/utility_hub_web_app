from utils.util import buildResponse

def lambda_handler(event, context):
    print(event)
    http_method = event['httpMethod']
    path = event['path']

    if http_method == 'GET' and path =='/home':
        return buildResponse(200, "OK")
    
    else:
        return buildResponse(404, "Resource not found")