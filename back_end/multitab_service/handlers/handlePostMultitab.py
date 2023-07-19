from utils.util import buildResponse
from utils.util import verifyAuthStatus
from utils.util import getAuthorizationCode
import json 

def handlePostMultitab(event):

    # This function will first check if the user is authenticated. Returns 401 error
    # This function will only return a JSON with all the default tiles and links for now.
    
    
    try:
        # Extract auth code
        code = getAuthorizationCode(event)
        if code is None:
            return buildResponse(401, "Unauthorized")
        else:
            if not verifyAuthStatus(code):
                return buildResponse(401, "Unauthorized")

        payload = [
        {
            "title": "Delco Operations",
            "description": "Grafana Dashboard to monitor during Delco Ops",
            "urls": [
                {
                    "urlTitle": "SOC :: Delco :: Business Metrics",
                    "url": "https://grafana.je-labs.com/d/NA80nq-Zk/soc-delco-business-metrics?orgId=1&refresh=1m"
                },
                {
                    "urlTitle": "SOC :: Delco :: Message Queues",
                    "url": "https://grafana.je-labs.com/d/ODEHK4EZz/soc-delco-message-queues?orgId=1&refresh=30s"
                },
                {
                    "urlTitle": "SOC :: Delco :: Payments",
                    "url": "https://grafana.je-labs.com/d/DtA1pkOGk/ca-payments-and-fraud-business-metrics?orgId=1&from=now-1h&to=now&refresh=30s"
                },
                {
                    "urlTitle": "SOC :: Delco :: RabbitMQ Metrics",
                    "url": "https://grafana.je-labs.com/d/b-fXG-PZz/rabbitmq-metrics?orgId=1&refresh=1m&from=now-1h&to=now"
                }
            ]
        },
        {
            "title": "Marketplace Operations",
            "description": "Grafana dashboard to monitor during marketplace ops",
            "urls": [
                {
                    "urlTitle": "Escalations-UK",
                    "url": "https://grafana.je-labs.com/d/000000651/escalations-uk?orgId=1&refresh=30s"
                },
                {
                    "urlTitle": "Escalations-INT",
                    "url": "https://grafana.je-labs.com/d/000001527/escalations-int?orgId=1&refresh=1m"
                },
                {
                    "urlTitle": "SOC - Deployments, Errors & Alerts",
                    "url": "https://grafana.je-labs.com/d/000001550/soc-deployments-errors-and-alerts?refresh=1m&orgId=1&var-Filters=JobFeature%7C%3D%7Cpublicweb&var-Filters=JobFeatureVersion%7C!%3D%7C1.0.0.554&from=now-1h&to=now&set_by_plugin=true"
                },
                {
                    "urlTitle": "SOC :: UK Highlevel",
                    "url": "https://grafana.je-labs.com/d/ZwvDCFgWz/soc-uk-highlevel?refresh=1m&orgId=1"
                },
                {
                    "urlTitle": "SOC-Order Rate Dashboard",
                    "url": "https://grafana.je-labs.com/d/000001951/soc-order-rate-dashboard?orgId=1&refresh=1m"
                },
                {
                    "urlTitle": "Authentication-Combined",
                    "url": "https://grafana.je-labs.com/d/LLf1LNi4z/authentication-combined?orgId=1&refresh=10s"
                }
            ]
        },
        {
            "title": "UK, INT, ANZ - Toggle CDN Provider- Web / Apps (INT/ANZ Only) CDN Failover test Instructions",
            "description": "Links to open when performing test to toggle CDN Provider",
            "urls": [
                {
                    "urlTitle": "Confluence Test instruction",
                    "url": "https://justeattakeaway.atlassian.net/wiki/spaces/SOC/pages/52742683/UK+INT+ANZ+-+Toggle+CDN+Provider-+Web+Apps+INT+ANZ+Only+CDN+Failover+test+Instructions"
                },
                {
                    "urlTitle": "AWS Account",
                    "url": "https://aws.just-eat.com/"
                },
                {
                    "urlTitle": "Global Watch Tower",
                    "url": "https://watchtower.eu-west-1.production.jet-internal.com/#/templates?template.name__icontains=toggle"
                },
                {
                    "urlTitle": "CDN check - Blackbox Exporter",
                    "url": "https://grafana.je-labs.com/d/pS6ZuGV7z34/cdn-check-blackbox-exporter?orgId=1&refresh=30s"
                },
                {
                    "urlTitle": "Operational Tech Tests Dashboard",
                    "url": "https://grafana.je-labs.com/d/JS4KpK3Zz/soc-operational-tech-tests?orgId=1&refresh=10s"
                }
            ]
        }
    ]
        
        return buildResponse(200, json.dumps(payload))
    
    except Exception as e:
        print('handlePostMultitab(): ' + str(e))
        return buildResponse(500, 'Internal Server error. Please try again')
