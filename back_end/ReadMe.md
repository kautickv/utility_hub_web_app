To install all dependencies:
    run - pip install -r requirments



Steps to setup backend:
 - Create a parameter store path. For instance /<app_name>
 - Create another path inside the above path for google client authentication. E.g /password_generator/google_client
 - Create a google OAuth consent screen and an Oauth Client ID. Download the client_secret.json file
 - Create a parameter store path. For instance <app_name>/google_client/client_id
 - Create a parameter store path. For instance <app_name>/google_client/client_secret
 - Create a parameter store path. For instance <app_name>/google_client/redirect_uri
 - Make sure the above values are encrypted.
