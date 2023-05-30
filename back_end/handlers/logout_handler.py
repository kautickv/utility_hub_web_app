from utils.util import buildResponse
from utils.GoogleAuth import GoogleAuth

def logout_handler(event, context):

    print(event)
    auth = GoogleAuth()
    # Extract token from headers
    try:
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
            return buildResponse(400, {"message": "Missing JWT token"})
        else:
            if (auth.logoutUser(token)):
                return buildResponse(200, {"message": "OK"})
            else:
                return buildResponse(400, {"message": "Bad request"})
    except Exception as e:
        return buildResponse(500, {"message": "Internal server error. Try again later"})