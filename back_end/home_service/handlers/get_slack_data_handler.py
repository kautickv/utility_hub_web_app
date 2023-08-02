from utils.util import buildResponse
from utils.SlackManager import SlackManager
import json
from datetime import datetime, timedelta


def get_slack_data_handler(numberOfDays, user_details):
    try:
            
        ## At this point, user is authenticated. Initialise slack Manager
        slack_client = SlackManager()

        # Getting list of channels to read from
        with open('home_config.json') as f:
            configs = json.load(f)
        channels = configs['slack_channels_to_monitor']

        #Set up time range
        start_time = datetime.now() - timedelta(days=int(numberOfDays))
        end_time = datetime.now()

        #Initialize dict
        all_messages = {}
        #Loop over channels and read messages
        for channel in channels:
            messages = slack_client.getMessageInChannelForTimeRange("C05KDHVA9E0",start_time,end_time)
            all_messages[slack_client.getChannelName(channel)] = messages
        
        return buildResponse(200, json.dumps(all_messages))
    
    except Exception as e:
        print(f"get_slack_data_handler(): ${e}")
        return buildResponse(500,"An error occurred. Please try again later")