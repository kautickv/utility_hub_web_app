from common.CommonUtility import CommonUtility
from utils.SlackManager import SlackManager
import json
from datetime import datetime, timedelta


def get_slack_data_handler(numberOfDays, user_details):
    try:

        # Initialize CommonUtility Class
        common_utility = CommonUtility()
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
            messages = slack_client.getMessageInChannelForTimeRange(channel,start_time,end_time)
            message = extractInfoFromSlackResponse(messages)
            all_messages[slack_client.getChannelName(channel)] = message
        
        return common_utility.buildResponse(200, json.dumps(all_messages))
    
    except Exception as e:
        print(f"get_slack_data_handler(): ${e}")
        return common_utility.buildResponse(500,"An error occurred. Please try again later")


def extractInfoFromSlackResponse(message):
    ##
    # PURPOSE: This function will take in the response from slack and extract
    #          only the useful information to return.
    # INPUT: The json returned from slack
    # OUTPUT: A streamline JSON object
    newArray = []
    for msg in message:
        msg_type = msg.get('type')
        msg_text = msg.get('text')
        msg_ts = msg.get('ts')
        newArray.append({"type": msg_type, "text": msg_text, "ts": msg_ts})
    
    return newArray