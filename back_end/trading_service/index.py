import json
from common.CommonUtility import CommonUtility
from handlers.handlePostTrading import handlePostTrading
from handlers.handleGetTrading import handleGetTrading

def lambda_handler(event, context):

    print(event)
    try:
        #initialise CommonUtility Class
        common_utility = CommonUtility()
        ## Check if user is authenticated
        code = common_utility.getAuthorizationCode(event)
        if code is None:
            return common_utility.buildResponse(401, "Unauthorized")
        else:
            ## VerifyAuthStatus will also return the user details associated with JWT Token
            user_details = common_utility.verifyAuthStatus(code)
            if user_details == None:
                return common_utility.buildResponse(401, "Unauthorized")
            
            if user_details['email'] != 'kautickv29@gmail.com':
                return common_utility.buildResponse(403, "Forbidden")
        
        http_method = event['httpMethod']
        path = event['path']

        if http_method == 'POST' and path =='/trading':
             # Parse the JSON body
            body = event.get('body', '{}')
            body_params = json.loads(body) if body else {}
            return handlePostTrading(body_params)
        
        elif http_method == 'GET' and path =='/trading':
            query_params = event.get('queryStringParameters', {})
            
            return handleGetTrading(query_params)
        else:
            return common_utility.buildResponse(404, "Resource not found")
    
    except Exception as e:
        print(f"An error occurred: ${e}")
        return common_utility.buildResponse(500, "Server error. Try again later")