from utils.util import buildResponse
from utils.util import verifyUserLoginStatus

def verify_handler(event, context):
    # This function will receive a request with JWT Token in HTTP header and verify if it's valid.
    # Returns 200 if valid, 401 if invalid and 500 if an error occurred.
    print(event)

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
            return buildResponse(401, {"message": "Missing JWT token"})
        else:
            if (verifyUserLoginStatus(token)):
                return buildResponse(200, {"message": "OK"})
            else:
                return buildResponse(401, {"message": "Unauthorized"})
    except Exception as e:
        return buildResponse(500, {"message": "Internal server error. Try again later"})