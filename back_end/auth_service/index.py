from utils.util import buildResponse
from handlers.get_creds_handler import get_creds_handler
from handlers.login_handler import login_handler
from handlers.logout_handler import logout_handler
from handlers.verify_handler import verify_handler
import json

def lambda_handler(event, context):

    print(event)
    http_method = event['httpMethod']
    path = event['path']

    if http_method == 'GET' and path =='/auth/creds':

        return get_creds_handler(event, context)
    
    elif http_method == 'POST' and path =='/auth/login':

        if (json.loads(event['body'])['code']):

            return login_handler(json.loads(event['body']))
        else:
            
            return buildResponse(400, {"message":"Bad Request"})
    
    elif http_method == 'POST' and path =='/auth/logout':

        return logout_handler(event, context)
    
    elif http_method == 'POST' and path =='/auth/verify':

        return verify_handler(event, context)
    
    else:
        
        return buildResponse(404, "Path not found")

