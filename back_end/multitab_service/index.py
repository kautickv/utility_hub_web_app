from common.CommonUtility import CommonUtility
from handlers.handlePostMultitab import handlePostMultitab
from handlers.handleGetMultitab import handleGetMultitab

def lambda_handler(event, context):
    print(event)
    http_method = event['httpMethod']
    path = event['path']

    # Initialize CommonUtility Class
    common_utility = CommonUtility()
    
    try:
        # Extract auth code
        code = common_utility.getAuthorizationCode(event)
        if code is None:
            return common_utility.buildResponse(401, "Unauthorized")
        else:
            ## VerifyAuthStatus will also return the user details associated with JWT Token
            user_details = common_utility.verifyAuthStatus(code)
            if user_details == None:
                return common_utility.buildResponse(401, "Unauthorized")
            
        if http_method == 'POST' and path =='/multitab':
            return handlePostMultitab(event)
    
        elif http_method == 'GET' and path =='/multitab':

            return handleGetMultitab(event)
        else:
            return common_utility.buildResponse(404, "Resource not found")
    
    except Exception as e:
        print(f"Error: ${e}")
        return common_utility.buildResponse(500, "An error occurred. Please try again later")