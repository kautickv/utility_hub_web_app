from utils.util import buildResponse
from utils.util import verifyAuthStatus
from utils.util import getAuthorizationCode
from utils.SlackManager import SlackManager
import json
from datetime import datetime, timedelta

def get_home_handler(event):

    print(event)

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
            
        ## At this point, user is authenticated. Initialise slack Manager
        slack_client = SlackManager()
        #slack_client.postMessageInChannel("C05KDHVA9E0", "Hello From lambda")

        # Reading from channel
        start_time = datetime.now() - timedelta(days=7)
        end_time = datetime.now()
        messages = slack_client.getMessageInChannelForTimeRange("C05KDHVA9E0",start_time,end_time)
        print(messages)
        return buildResponse(200, json.dumps(messages))
    
    except Exception as e:
        print(f"get_home_handler(): ${e}")
        return buildResponse(500,"An error occurred. Please try again later")