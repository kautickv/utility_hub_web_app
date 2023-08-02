from utils.util import buildResponse
from utils.SlackManager import SlackManager
import json
from datetime import datetime, timedelta


def get_slack_data_handler(numberOfDays, user_details):
    try:
            
        ## At this point, user is authenticated. Initialise slack Manager
        slack_client = SlackManager()

        # Reading from channel
        start_time = datetime.now() - timedelta(days=numberOfDays)
        end_time = datetime.now()
        messages = slack_client.getMessageInChannelForTimeRange("C05KDHVA9E0",start_time,end_time)
        print(messages)
        return buildResponse(200, json.dumps(messages))
    
    except Exception as e:
        print(f"get_slack_data_handler(): ${e}")
        return buildResponse(500,"An error occurred. Please try again later")