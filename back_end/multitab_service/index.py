from common.CommonUtility import CommonUtility
from handlers.handlePostMultitab import handlePostMultitab
from handlers.handleGetMultitab import handleGetMultitab

def lambda_handler(event, context):
    print(event)
    http_method = event['httpMethod']
    path = event['path']

    #initialize CommonUtility Class
    common_utility = CommonUtility()
    if http_method == 'POST' and path =='/multitab':
        return handlePostMultitab(event)
    
    elif http_method == 'GET' and path =='/multitab':

        return handleGetMultitab(event)
    else:
        return common_utility.buildResponse(404, "Resource not found")