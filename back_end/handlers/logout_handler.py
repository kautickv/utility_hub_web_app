from utils.util import buildResponse

def logout_handler(event, context):

    return buildResponse(200, {"message": "OK"})