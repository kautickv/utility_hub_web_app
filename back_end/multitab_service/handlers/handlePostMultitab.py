from common.CommonUtility import CommonUtility
from utils.util import compress_json
from utils.util import decompress_json
from datetime import datetime
from utils.BookmarksTableManager import BookmarksTableManager
from common.Logger import Logger

import os
import json 

def handlePostMultitab(event, user_details):

    # This function will first check if the user is authenticated. Returns 401 error
    # This function is called when user wants to modify their bookmarks. 
    # It will save the configuration in the multitab table.
    
    
    try:
        # Initialize CommonUtility Class
        common_utility = CommonUtility()
        #Initialise Logging instance
        logging_instance = Logger()

        ## User verified to be authenticated. Now, update the config in database.
        configTableManager = BookmarksTableManager(os.getenv('BOOKMARKS_TABLE_NAME'))
        # Parse the body content into a dictionary
        body_content = json.loads(event['body'])
         # Compress the config_json before storing
        compressed_config_json = compress_json(body_content['config_json'])
        print(compressed_config_json)
        print("Decompressing")
        print(decompress_json(compressed_config_json))
        config_data = {
            'email': user_details['email'],
            'config_json': compressed_config_json
        }
        ## Update the config for user.
        if (configTableManager.update_user_data(email=config_data['email'], config_json=config_data['config_json'], last_modified=str(datetime.utcnow()))):
            return common_utility.buildResponse(200, "OK")
        else:
            return common_utility.buildResponse(500, "An error occurred updating configuration")
    
    except Exception as e:
        logging_instance.log_exception(e, 'handlePostMultitab')
        return common_utility.buildResponse(500, 'Internal Server error. Please try again')
