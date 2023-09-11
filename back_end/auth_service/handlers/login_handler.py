from common.CommonUtility import CommonUtility
from utils.GoogleAuth import GoogleAuth
from utils.util import decode_jwt_token
from common.Logger import Logger


def login_handler(body):
    # This function will receive the code provided by google. And handle the login flow

    try:
        # Initialise CommonUtility class
        common_utils = CommonUtility()
        # Create an instance of GoogleAuth
        auth = GoogleAuth()
        # It should use the code and exchange it for a token and get user information.
        if (not auth.exchange_code_for_token(body)):
            return common_utils.buildResponse(500, {"message":"Internal server error exchanging tokens"})
        
        # Get user information from access tokens
        if (not auth.get_user_info_from_google()):
            return common_utils.buildResponse(500, {"message":"Internal server error getting auth"})
        
        #Add those user information in the database
        if (not auth.add_user_info_in_db()):
            return common_utils.buildResponse(500, {"message":"Internal server error adding in DB"})
        
        # Generate a jwt token and set it as the response header/or return in http body.
        return common_utils.buildResponse(200, {"message": "OK", "JWT_Token": auth.get_jwt_token(), "payload":decode_jwt_token(auth.get_jwt_token)})
    except Exception as e:
        #Initialise Logging instance
        logging_instance = Logger()
        logging_instance.log_exception(e, 'login_handler')
        return common_utils.buildResponse(500, "Internal server error. Please try again later")
