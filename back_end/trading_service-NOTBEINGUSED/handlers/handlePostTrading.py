from common.CommonUtility import CommonUtility

def handlePostTrading(event):

    # Initialize CommonUtility Class
    common_utility = CommonUtility()
    return common_utility.buildResponse(200, "OK")