from common.CommonUtility import CommonUtility
from handlers.get_slack_data_handler import get_slack_data_handler
from utils.util import verifyAuthStatus
from utils.util import getAuthorizationCode

def lambda_handler(event, context):
    print(event)
    http_method = event['httpMethod']
    path = event['path']

    # Initialize CommonUtility Class
    common_utility = CommonUtility()
    # Getting data from [slack, jira]
    getDataFrom = event['queryStringParameters']['from'].strip()
    try:
        # Extract auth code
        code = getAuthorizationCode(event)
        if code is None:
            return common_utility.buildResponse(401, "Unauthorized")
        else:
            ## VerifyAuthStatus will also return the user details associated with JWT Token
            user_details = verifyAuthStatus(code)
            if user_details == None:
                return common_utility.buildResponse(401, "Unauthorized")
            
        if http_method == 'GET' and path =='/home' and getDataFrom == 'slack':
            return get_slack_data_handler(event['queryStringParameters']['number_days'], user_details)
    
        else:
            return common_utility.buildResponse(404, "Resource not found")
    
    except Exception as e:
        print(f"Error: ${e}")
        return common_utility.buildResponse(500, "An error occurred. Please try again later")