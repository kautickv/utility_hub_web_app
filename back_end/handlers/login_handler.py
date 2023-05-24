from utils.util import buildResponse
from utils.DynamoDBManager import DynamoDBManager
from utils.auth import exchange_code_for_token
from utils.auth import get_user_info_from_google


def login_handler(body):
    # This function will receive the code provided by google.
    # It should use the code and exchange it for a token and get user information.
    token = exchange_code_for_token(body)
    
    # Get user information from access tokens
    userInfo = get_user_info_from_google(token)
    print(userInfo)
    #Add those user information in the database
    # Generate a jwt token and set it as the response header/or return in http body.
    return buildResponse(200, {"message": "OK"})