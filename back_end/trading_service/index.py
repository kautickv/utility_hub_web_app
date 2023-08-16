from utils.util import buildResponse,getAuthorizationCode,verifyAuthStatus
from handlers.handlePostTrading import handlePostTrading
from handlers.handleGetTrading import handleGetTrading
from handlers.handleScheduleTradingEvent import handleScheduleTradingEvent
def lambda_handler(event, context):

    print(event)
    try:
        ## Check if it's a schedule event by event bridge
        if(event.get('detail-type') != None):
            handleScheduleTradingEvent()
            return None
        
        ## Check if user is authenticated
        code = getAuthorizationCode(event)
        if code is None:
            return buildResponse(401, "Unauthorized")
        else:
            ## VerifyAuthStatus will also return the user details associated with JWT Token
            user_details = verifyAuthStatus(code)
            if user_details == None:
                return buildResponse(401, "Unauthorized")
            
            if user_details['email'] != 'kautickv29@gmail.com':
                return buildResponse(403, "Forbidden")
        
        http_method = event['httpMethod']
        path = event['path']

        if http_method == 'POST' and path =='/trading':
            return handlePostTrading(event)
        
        elif http_method == 'GET' and path =='/trading':

            return handleGetTrading(event)
        else:
            return buildResponse(404, "Resource not found")
    
    except Exception as e:
        print(f"An error occurred: ${e}")
        return buildResponse(500, "Server error. Try again later")