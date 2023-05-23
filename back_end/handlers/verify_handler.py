from utils.util import buildResponse

def verify_handler(event, context):

    return buildResponse(200, {"message": "OK"})