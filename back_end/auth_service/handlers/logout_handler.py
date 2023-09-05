from common.CommonUtility import CommonUtility
from utils.GoogleAuth import GoogleAuth

def logout_handler(event, context):

    print(event)
    #Initialise CommonUtility Class
    common_utility = CommonUtility()
    # Initialize GoogleAuth class
    auth = GoogleAuth()
    
    try:
        # Extract token from headers
        if "Authorization" in event["headers"]:
            authorization_header = event["headers"]["Authorization"]
            if authorization_header.startswith("Bearer "):
                split_header = authorization_header.split()
                if len(split_header) > 1:
                    token = split_header[1].strip()
                else:
                    token = None
            else:
                token = None
        else:
            token = None
        
        if token is None:
            return common_utility.buildResponse(400, {"message": "Missing JWT token"})
        else:
            if (auth.logoutUser(token)):
                return common_utility.buildResponse(200, {"message": "OK"})
            else:
                return common_utility.buildResponse(400, {"message": "Bad request"})
    except Exception as e:
        return common_utility.buildResponse(500, {"message": "Internal server error. Try again later"})