from utils.util import buildResponse
from utils.util import verifyAuthStatus
from handlers.handlePostMultitab import handlePostMultitab
from handlers.handleGetMultitab import handleGetMultitab

def lambda_handler(event, context):
    print(event)
    http_method = event['httpMethod']
    path = event['path']

    if http_method == 'POST' and path =='/multitab':
        return handlePostMultitab(event)
    
    elif http_method == 'GET' and path =='/multitab':

        return handleGetMultitab(event)
    else:
        return buildResponse(404, "Resource not found")