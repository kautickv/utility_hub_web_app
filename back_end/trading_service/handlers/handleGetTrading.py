from utils.util import buildResponse
from utils.CryptoDotComExchangeManager import CryptoDotComExchangeManager

def handleGetTrading(event):
    
    try:
        # Create Exchange manager class
        cryptoExchange = CryptoDotComExchangeManager()

        # Get current BTC price
        cryptoExchange.getCrrentPriceForTicker("BTC")
    except Exception as e:
        print(f"handleGetTrading(): ${e}")
        return buildResponse(500, "A server error occurred. Please try again later")