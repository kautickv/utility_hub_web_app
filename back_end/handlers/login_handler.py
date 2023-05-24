from utils.util import buildResponse
from utils.DynamoDBManager import DynamoDBManager
from utils.GoogleAuth import GoogleAuth


def login_handler(body):
    # This function will receive the code provided by google. And handle the login flow

    # Create an instance of GoogleAuth
    auth = GoogleAuth()
    # It should use the code and exchange it for a token and get user information.
    token = auth.exchange_code_for_token(body)
    
    # Get user information from access tokens
    userInfo = auth.get_user_info_from_google(token)
    print(userInfo)
    #Add those user information in the database
    # Generate a jwt token and set it as the response header/or return in http body.
    return buildResponse(200, {"message": "OK"})