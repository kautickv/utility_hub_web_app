import boto3
import json

class CryptoDotComExchangeManager:
    
    api_access_key = None
    api_secret_key = None
    api_base_url = "https://api.crypto.com/exchange/v1/"

    def __init__(self):
        keys = self._get_api_keys()
        self.api_access_key = keys[0]
        self.api_secret_key = keys[1]

    def _get_api_keys():
        ##
        # PURPOSE: This function will read the value of the access and secret from SSM parameter store
        # INPUT: none
        # OUTPUT: An array [access Key, secret Key]
        ##
        try:
            # Create a Boto3 client for SSM
            ssm_client = boto3.client('ssm')
            # Read configuration file
            with open('trading_config.json') as f:
                configs = json.load(f)
            # Retrieve the access key
            response = ssm_client.get_parameter(
                Name=configs['ssm_parameter_paths_crypto.com_keys']['access_key'],
                WithDecryption=True
            )
            # Extract access key
            access_key = response['Parameter']['Value']

            # retrive secret key
            response = ssm_client.get_parameter(
                Name=configs['ssm_parameter_paths_crypto.com_keys']['secret_key'],
                WithDecryption=True
            )
            # Extract Secret key
            secret_key = response['Parameter']['Value']

            return [access_key, secret_key]
        
        except Exception as e:
            print(f"Error in reading crypto.com api keys. Error: {str(e)}")
            raise Exception("Error: " + str(e))