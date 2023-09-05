from common.CommonUtility import CommonUtility
from utils.util import verifyUserLoginStatus
from utils.util import decode_jwt_token
from common.Logger import Logger

def verify_handler(event, context):
    # This function will receive a request with JWT Token in HTTP header and verify if it's valid.
    # Returns 200 if valid, 401 if invalid and 500 if an error occurred.
    print(event)
    #Initialize CommonUtility Class
    common_utility = CommonUtility()
    # Extract token from headers
    token = None
    try:
        if "headers" in event and "Authorization" in event["headers"]:
            authorization_header = event["headers"]["Authorization"]
            if authorization_header.startswith("Bearer "):
                split_header = authorization_header.split()
                if len(split_header) > 1:
                    token = split_header[1].strip()
                else:
                    token = None
            else:
                token = None
        # Authorization can also be in body
        elif "Authorization" in event:
            authorization_header = event["Authorization"]
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
            return common_utility.buildResponse(401, {"message": "Missing JWT token"})
        else:
            if (verifyUserLoginStatus(token)):
                return common_utility.buildResponse(200, {"token_details": decode_jwt_token(token)})
            else:
                return common_utility.buildResponse(401, {"message": "Unauthorized"})
    except Exception as e:
        #Initialise Logging instance
        logging_instance = Logger()
        logging_instance.log_exception(e, 'verify_handler')
        return common_utility.buildResponse(500, {"message": "Internal server error. Try again later"})