import boto3
import json
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
from common.Logger import Logger

class SlackManager:
    
    client = None

    def __init__(self):

        try:
            slackToken = self._getSlackBotTokenFromSSM()
            # create a client instance
            self.client = WebClient(token=slackToken)
            #Initialise Logging instance
            self.logging_instance = Logger()

        except Exception as e:
            raise Exception (f'Initialising Slack Manager error: ${e}')
    
    

    def postMessageInChannel(self, channelId, message):
        ##
        #PURPOSE: This function will be used to send message to a specific channel in slack.
        #INPUT: Channel ID and the message to send
        #OUTPUT: True is success, false if not and error if an error occurred.

        try:
            # post a message to the channel
            response = self.client.chat_postMessage(channel=channelId, text=message)
            return response["message"]["text"] == message
        
        except Exception as e:
            self.logging_instance.log_exception(e, 'postMessageInChannel')
            raise
        

    def getMessageInChannelForTimeRange(self, channelId, startTime, endTime):
        ##
        #PURPOSE: This function will be used to read messages from a specific
        #         channel for the given time range
        #INPUT: Channel ID, start and end time during which to retrieve message
        #OUTPUT: A list of all the messages.

        # Convert datetime objects to timestamps
        start_timestamp = startTime.timestamp()
        end_timestamp = endTime.timestamp()

        try:
            # Fetch the messages
            response = self.client.conversations_history(
                channel=channelId,
                oldest=start_timestamp,
                latest=end_timestamp,
                inclusive=True
            )

            messages = response['messages']
            return messages
        
        except Exception as e:
            self.logging_instance.log_exception(e, 'getMessageInChannelForTimeRange')
            raise
        

    def _getSlackBotTokenFromSSM(self):

        # Read Slack bot token from SSM Paramater store
        ssm_client = boto3.client('ssm')
        try:
            with open('home_config.json') as f:
                configs = json.load(f)
            response = ssm_client.get_parameter(
                    Name=configs['ssm_parameter_paths_slack_bot_token']['bot_user_oauth_token'],
                    WithDecryption=True
                )
            secret_key = response['Parameter']['Value']
            return secret_key
    
        except Exception as e:
            self.logging_instance.log_exception(e, '_getSlackBotTokenFromSSM')
            raise

    def getChannelName (self, channelId):
        # This function will return the channel name given the channel id

        try:
            # Get the channel information
            response = self.client.conversations_info(
                channel=channelId
            )

            return response['channel']['name']
        except Exception as e:
            self.logging_instance.log_exception(e, 'getChannelName')
            raise