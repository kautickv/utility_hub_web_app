from utils.util import buildResponse
from utils.TradingTableManager import TradingTableManager

def handleGetTrading(event):
    
    try:
        databaseTableManager = TradingTableManager("password-generator_crypto_trading_table")
        
        body = event.get('body')
        print(body)

        # Get info from database
        crypto_signals = databaseTableManager.get_items(5)

        print(crypto_signals)

        return buildResponse(200, "OK")
       
    except Exception as e:
        print(f"handleGetTrading(): ${e}")
        return buildResponse(500, "A server error occurred. Please try again later")