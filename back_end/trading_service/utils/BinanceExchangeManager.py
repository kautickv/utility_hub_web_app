import requests

class BinanceExchange():

    rest_base_url = "https://api.binance.com/api/v3/"
    def __init__(self):
        pass


    def getCrrentPriceForTicker(self, ticker, base_currency):
        ##
        # PURPOSE: This function will return the current usd price for the crypto ticker symbol
        # INPUT: Ticker symbol as string. E.g BTC, ETH and base_currency
        # OUTPUT: A list of a couple of information for current ticker
        ##

        try:
            #send api call
            response = requests.get(f"{self.api_base_url}ticker?symbol={ticker}{base_currency}")
            # View sample response here: https://binance-docs.github.io/apidocs/spot/en/#symbol-order-book-ticker
            if (response.status_code == 200):
                ticker_data = response.json()
                if ticker_data["code"] == 0:
                    return ticker_data
                else:
                    raise Exception(f"Binance returned: {response.text}")
            else:
                raise Exception("Could not get ticker price")
        except Exception as e:
            print(f"getCurrentPriceForTicker(): {e}")
            raise Exception(f"Could not get ticker price from Binance: {e}")