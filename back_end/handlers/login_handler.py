from utils.util import buildResponse
from utils.DynamoDBManager import DynamoDBManager
from utils.GoogleAuth import GoogleAuth


def login_handler(body):
    # This function will receive the code provided by google. And handle the login flow

    # Create an instance of GoogleAuth
    auth = GoogleAuth()
    # It should use the code and exchange it for a token and get user information.
    if (not auth.exchange_code_for_token(body)):
        return buildResponse(500, {"message":"Internal server error exchanging tokens"})
    
    # Get user information from access tokens
    if (not auth.get_user_info_from_google()):
        return buildResponse(500, {"message":"Internal server error getting auth"})
    
    #Add those user information in the database
    if (not auth.add_user_info_in_db()):
        return buildResponse(500, {"message":"Internal server error adding in DB"})
    
    # Generate a jwt token and set it as the response header/or return in http body.
    return buildResponse(200, {"message": "OK"})