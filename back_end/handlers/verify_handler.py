from utils.util import buildResponse
from utils.util import verifyUserLoginStatus

def verify_handler(event, context):
    # This function will receive a request with JWT Token in HTTP header and verify if it's valid.
    # Returns 200 if valid, 401 if invalid and 500 if an error occurred.
    print(event)

    try:
        if (verifyUserLoginStatus("")):
            return buildResponse(200, {"message": "OK"})
        else:
            return buildResponse(401, {"message": "Unauthorized"})
    except Exception as e:
        return buildResponse(500, {"message": "Internal server error. Try again later"})