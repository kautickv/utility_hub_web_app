from utils.util import buildResponse

def verify_handler(event, context):
    # This function will receive a request with JWT Token in HTTP header and verify if it's valid.
    # Returns 200 if valid, 401 if invalid and 500 if an error occurred.
    print(event)

    

    return buildResponse(200, {"message": "OK"})