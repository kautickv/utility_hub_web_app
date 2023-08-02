from utils.util import buildResponse
from handlers.get_home_handler import get_home_handler

def lambda_handler(event, context):
    print(event)
    http_method = event['httpMethod']
    path = event['path']

    if http_method == 'GET' and path =='/home':
        return get_home_handler(event)
    
    else:
        return buildResponse(404, "Resource not found")