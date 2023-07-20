from utils.util import buildResponse
from utils.util import verifyAuthStatus
from handlers.handlePostMultitab import handlePostMultitab

def lambda_handler(event, context):
    print(event)
    http_method = event['httpMethod']
    path = event['path']

    if http_method == 'POST' and path =='/multitab':
        return handlePostMultitab(event)
    
    elif http_method == 'GET' and path =='/auth/login':

        return buildResponse(200, "OK")
    else:
        return buildResponse(404, "Resource not found")