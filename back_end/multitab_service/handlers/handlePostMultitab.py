from utils.util import buildResponse
from utils.util import verifyAuthStatus
from utils.util import getAuthorizationCode
import json 

def handlePostMultitab(event):

    # This function will first check if the user is authenticated. Returns 401 error
    # This function is called when user wants to modify their bookmarks. 
    # It will save the configuration in the multitab table.
    
    
    try:
        # Extract auth code
        code = getAuthorizationCode(event)
        if code is None:
            return buildResponse(401, "Unauthorized")
        else:
            if not verifyAuthStatus(code):
                return buildResponse(401, "Unauthorized")

        ## User verified to be authenticated. Now, update the config in database.
        return buildResponse(200, "OK")
    
    except Exception as e:
        print('handlePostMultitab(): ' + str(e))
        return buildResponse(500, 'Internal Server error. Please try again')
