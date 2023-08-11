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

    def getCoinBalance(self, ticker):
        ##
        # PURPOSE: Get the coin balance in spot account. 
        # INPUT: Ticker symbol as string. E.g BTC, ETH
        # OUTPUT: A list of json elements containing multiple info about balance.
        #         If ticker is ALL, it will return the balances for all coins in the account
        # Docs: https://exchange-docs.crypto.com/spot/index.html#private-get-account-summary
        ##

        try:
            print(ticker)
        except Exception as e:
            print(f"getCoinBalance(): {e}")
            raise Exception (f"Could not get coin balance for {ticker}.")
    
    def getTimeSeriesDataForTicker(self, ticker, candleTimeFrame):
        ##
        # PURPOSE: Get the candle stick open and closing price for the specified time frame
        # INPUT: Ticker symbol as string. E.g BTC, ETH compared to USD, and 
        #        candleTimeFrame, e.g 5m, 1h, 1D, 1M (Only specific timeframe works. Look up docs)
        # OUTPUT: A list of json elements containing multiple info. Look up docs.
        # Docs: https://exchange-docs.crypto.com/spot/index.html#public-get-candlestick
        ##
        try:
            #send api call
            response = requests.get(f"{self.api_base_url}public/get-ticker?instrument_name=${ticker}_USD&timeframe={candleTimeFrame}")
            if (response.status_code == 200):
                ticker_data = response.text
                ticker_data = json.loads(ticker_data)
                return ticker_data['result']['data']
            else:
                raise Exception("Could not get ticker price")
        except Exception as e:
            print(f"getTimeSeriesDataForTicker(): ${e}")
            raise Exception(f"Could not get ticker candlestick for {ticker}")

    def getCrrentPriceForTicker(self, ticker):
        ##
        # PURPOSE: This function will return the current usd price for the crypto ticker symbol
        # INPUT: Ticker symbol as string. E.g BTC, ETH
        # OUTPUT: A list of a couple of information for current ticker
        ##

        try:
            #send api call
            response = requests.get(f"{self.api_base_url}public/get-ticker?instrument_name=${ticker}_USD")
            print(f"{self.api_base_url}public/get-ticker?instrument_name={ticker}_USD")
            # View sample response here: https://exchange-docs.crypto.com/spot/index.html#public-get-ticker
            if (response.status_code == 200):
                ticker_data = response.text
                ticker_data = json.loads(ticker_data)
                return ticker_data['result']['data']
            else:
                raise Exception("Could not get ticker price")
        except Exception as e:
            print(f"getCurrentPriceForTicker(): ${e}")
            raise Exception("Could not get ticker price")


    def _get_api_keys(self):
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