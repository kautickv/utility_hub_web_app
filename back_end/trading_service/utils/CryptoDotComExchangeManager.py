import boto3
import json
import requests

class CryptoDotComExchangeManager:
    
    api_access_key = None
    api_secret_key = None
    api_base_url = "https://api.crypto.com/v2/"

    def __init__(self):
        keys = self._get_api_keys()
        self.api_access_key = keys[0]
        self.api_secret_key = keys[1]


    def getCrrentPriceForTicker(self, ticker):
        ##
        # PURPOSE: This function will return the current usd price for the crypto ticker symbol
        # INPUT: Ticker symbol as string. E.g BTC, ETH
        # OUTPUT: Current price as a double
        ##

        try:
            #send api call
            response = requests.get(f"${self.api_base_url}public/get-ticker?instrument_name=${ticker}_USDT")
            print(response)
            return response
        except Exception as e:
            print(f"getCurrentPriceForTicker(): ${e}")
            raise Exception("Could not get ticker price")


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