from utils.util import buildResponse
from utils.util import verifyAuthStatus
from handlers.handlePostMultitab import handlePostMultitab

def lambda_handler(event, context):
    print(event)
    http_method = event['httpMethod']
    path = event['path']

    if http_method == 'POST' and path =='/multitab':
        return handlePostMultitab(event, context)
    else:
        return buildResponse(404, "Resource not found")