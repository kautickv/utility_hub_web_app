from utils.util import buildResponse


def lambda_handler(event, context):

    print(event)
    return buildResponse(200, "OK")