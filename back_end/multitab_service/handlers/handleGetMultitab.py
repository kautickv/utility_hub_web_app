from common.CommonUtility import CommonUtility
from utils.util import verifyAuthStatus
from utils.util import getAuthorizationCode
from utils.BookmarksTableManager import BookmarksTableManager
from utils.util import decompress_json

import json 
import os
import traceback


def handleGetMultitab(event):

    # This function will first check if the user is authenticated. Returns 401 error
    # This function is called when user wants to modify their bookmarks. 
    # It will save the configuration in the multitab table.
    
    
    try:
        # Initialize CommonUtility Class
        common_utility = CommonUtility()
        # Extract auth code
        code = getAuthorizationCode(event)
        if code is None:
            return common_utility.buildResponse(401, "Unauthorized")
        else:
            ## VerifyAuthStatus will also return the user details associated with JWT Token
            user_details = verifyAuthStatus(code)
            if user_details == None:
                return common_utility.buildResponse(401, "Unauthorized")
        ## User verified to be authenticated. Now, update the config in database.
        configTableManager = BookmarksTableManager(os.getenv('BOOKMARKS_TABLE_NAME'))
        compressed_config_json = configTableManager.get_user_data(user_details['email'])
        if compressed_config_json == None:
            # Return default config only.
            with open('trading_config.json') as f:
                configs = json.load(f)
            return common_utility.buildResponse(200, json.dumps(json.dumps(configs['default_cards']))) 
        
        config = decompress_json(compressed_config_json)

        return common_utility.buildResponse(200, json.dumps(config))
    
    except Exception as e:
        print('handlePostMultitab(): ' + str(e))
        traceback.print_exc()  
        return common_utility.buildResponse(500, 'Internal Server error. Please try again')
