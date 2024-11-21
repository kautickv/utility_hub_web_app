from common.CommonUtility import CommonUtility
import json
from datetime import datetime, timedelta
from common.Logger import Logger

def get_slack_data_handler(numberOfDays, user_details):
    try:

        # Initialize CommonUtility Class
        common_utility = CommonUtility()
        ## At this point, user is authenticated.
        # Getting list of channels to read from
        with open('home_config.json') as f:
            configs = json.load(f)
        
        return common_utility.buildResponse(200, json.dumps("OK"))
    
    except Exception as e:
        #Initialise Logging instance
        logging_instance = Logger()
        logging_instance.log_exception(e, 'get_slack_data_handler')
        return common_utility.buildResponse(500,"An error occurred. Please try again later")