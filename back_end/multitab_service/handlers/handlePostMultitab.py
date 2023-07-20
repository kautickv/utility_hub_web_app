from utils.util import buildResponse
from utils.util import verifyAuthStatus
from utils.util import getAuthorizationCode
from datetime import datetime
from utils.BookmarksTableManager import BookmarksTableManager
import traceback

import os
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
            ## VerifyAuthStatus will also return the user details associated with JWT Token
            user_details = verifyAuthStatus(code)
            if user_details == None:
                return buildResponse(401, "Unauthorized")

        ## User verified to be authenticated. Now, update the config in database.
        configTableManager = BookmarksTableManager(os.getenv('BOOKMARKS_TABLE_NAME'))
        # Parse the body content into a dictionary
        body_content = json.loads(event['body'])
        config_data = {
            'email': user_details['email'],
            'config_json': json.dumps(body_content['config_json'])
        }
        ## Update the config for user.
        if (configTableManager.update_user_data(email=config_data['email'], config_json=config_data['config_json'], last_modified=str(datetime.utcnow()))):
            return buildResponse(200, "OK")
        else:
            return buildResponse(500, "An error occurred updating configuration")
    
    except Exception as e:
        print('handlePostMultitab(): ' + str(e))
        traceback.print_exc()  # This will print the whole stack trace
        return buildResponse(500, 'Internal Server error. Please try again')
