from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

# create a client instance
client = WebClient(token="xoxb-4396794672741-5659464237908-rgSFWJBxsMPhUg8nlLUYf5Re")

try:
    # post a message to the channel
    response = client.chat_postMessage(channel="#help-slackbot-tests", text="Hello, world!")
    assert response["message"]["text"] == "Hello, world!"
except SlackApiError as e:
    # You will get a SlackApiError if "ok" is False
    assert e.response["ok"] is False
    assert e.response["error"]  # str like 'invalid_auth', 'channel_not_found'
    print(f"Got an error: {e.response['error']}")
