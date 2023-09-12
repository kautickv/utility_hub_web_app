from common.CommonUtility import CommonUtility
from utils.BookmarksTableManager import BookmarksTableManager
from utils.util import decompress_json
import json 
import os
from common.Logger import Logger

def handleGetMultitab(event, user_details):

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
        compressed_config_json = configTableManager.get_user_data(user_details['email'])
        if compressed_config_json == None:
            # Return default config only.
            with open('multitab_config.json') as f:
                configs = json.load(f)
            return common_utility.buildResponse(200, json.dumps(json.dumps(configs['default_cards']))) 
        
        config = decompress_json(compressed_config_json)

        return common_utility.buildResponse(200, json.dumps(config))
    
    except Exception as e:
        logging_instance.log_exception(e, 'handleGetMultitab') 
        return common_utility.buildResponse(500, 'Internal Server error. Please try again')
