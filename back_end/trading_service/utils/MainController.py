import json
import time
from CoinController import CoinController

class MainController():

    _crypto_list = []
    _interval = "6h"
    _allCoinsSignals = [] # Will store the signals for all coins.

    def __init__(self):
        ###
        # PURPOSE: This constructor will read all the crypto pair from trading_config.json and 
        #          initialise a list.
        try:
            with open('../trading_config.json') as f:
                configs = json.load(f)
            
            for pair in configs['trading_pairs_to_monitor']:
                self._crypto_list.append({
                    "ticker": pair.split("_")[0],
                    "base_currency": pair.split("_")[1]
                })

        except Exception as e:
            print(f"Could not initialise MainController: {e}")
            raise Exception(f"Could not initialse MainController oject: {e}")
        
    
    def getAllSignals(self):
        ###
        # PURPOSE: This function will get the BUY and SELL signals for all crypto pair being monitored.
        # INPUT: None
        # OUTPUT: A list of all crypto pairs with the signals for all indicators.

        #Re-initialize array
        self._allCoinsSignals = []
        try:
            # Loop through coin list
            for coin in self._crypto_list:
                try:
                    coinController = CoinController(self._interval, coin['ticker'], coin['base_currency'])
                    self._allCoinsSignals.append({
                        "ticker": coin['ticker'],
                        "base_currency": coin['base_currency'],
                        "ema_signal": coinController.getEMASignal(short_period=20, long_period=200, threshold = 0.03),  # 3% deviation
                        "rsi_signal": coinController.getRSI_Signal(),  # defaults to lookback=5
                        "volume_signal": coinController.getVolumeSignal(50), # Defaults to lookback=10
                        "bollinger_signal": coinController.getBollingerSignal()
                    })
                    print(f"Got info for {coin['ticker']}")
                    time.sleep(3)  # Sleep for 3 seconds
                except Exception as el:
                    print(f"Could not get Data for {coin['ticker']}_{coin['base_currency']} pair")
                    continue # continue with next coin

            return self._allCoinsSignals

        except Exception as e:
            print(f"getAllSignals(): {e}")
            raise Exception(f"An error occurred while getting signals for all coins: {e}")