from utils.util import buildResponse
from utils.MainController import MainController
from utils.TradingTableManager import TradingTableManager

def handleGetTrading(event):
    
    try:
        databaseTableManager = TradingTableManager("password-generator_crypto_trading_table")
        crypto_data = {'ticker': 'BTC', 'base_currency': 'USDT', 'ema_signal': 'NEUTRAL', 'rsi_signal': 'NEUTRAL', 'volume_signal': 'SELL', 'bollinger_signal': 'NEUTRAL'}

        response = databaseTableManager.add_item(crypto_data)
        print(response)

        return buildResponse(200, "OK")
       
    except Exception as e:
        print(f"handleGetTrading(): ${e}")
        return buildResponse(500, "A server error occurred. Please try again later")