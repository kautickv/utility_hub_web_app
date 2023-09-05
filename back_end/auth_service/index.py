from common.CommonUtility import CommonUtility
from handlers.get_creds_handler import get_creds_handler
from handlers.login_handler import login_handler
from handlers.logout_handler import logout_handler
from handlers.verify_handler import verify_handler
from common.Logger import Logger
import json

def lambda_handler(event, context):

    print(event)
    http_method = event['httpMethod']
    path = event['path']

    try:
        # Initialise CommonUtility class
        common_utility = CommonUtility()
        if http_method == 'GET' and path =='/auth/creds':

            return get_creds_handler(event, context)
        
        elif http_method == 'POST' and path =='/auth/login':

            if (json.loads(event['body'])['code']):

                return login_handler(json.loads(event['body']))
            else:
                
                return common_utility.buildResponse(400, {"message":"Bad Request"})
        
        elif http_method == 'POST' and path =='/auth/logout':

            return logout_handler(event, context)
        
        elif http_method == 'POST' and path =='/auth/verify':

            return verify_handler(event, context)
        
        else:
            
            return common_utility.buildResponse(404, "Path not found")
        
    except Exception as e:
        #Initialise Logging instance
        logging_instance = Logger()
        logging_instance.log_exception(e, 'auth_service')

        return common_utility.buildResponse(500, "Internal Server error. Please try again later.")


