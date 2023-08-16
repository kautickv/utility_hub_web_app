from utils.MainController import MainController
from utils.TradingTableManager import TradingTableManager

def handleScheduleTradingEvent():
    
    try:
        mainController = MainController()

        # Get all crypto signals
        all_crypto = mainController.getAllSignals()

        #Open connection to database
        databaseTableManager = TradingTableManager("password-generator_crypto_trading_table")

        # save each in database
        for coin in all_crypto:
            try:
                responce = databaseTableManager.add_item(coin)
            except Exception as e:
                print(f"Could not add coin {coin['ticker']} in database")
                continue
    except Exception as e:
        print(f"handleScheduleTradingEvent(): {e}")
        raise Exception(f"Error getting all cryto signals: {e}")