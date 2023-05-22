import json
from utils.util import buildResponse
from handlers.get_creds_handler import get_creds_handler
def lambda_handler(event, context):

    http_method = event['httpMethod']
    path = event['path']

    if http_method == 'GET' and path =='/auth/creds':
        return get_creds_handler(event, context)
    else:
        return buildResponse(404, "Path not found")

