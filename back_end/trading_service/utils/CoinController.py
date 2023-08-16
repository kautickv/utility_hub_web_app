from utils.BinanceExchangeManager import BinanceExchangeManager
from utils.Indicators import Indicators
import numpy as np
from statsmodels.distributions.empirical_distribution import ECDF

###
# PURPOSE: This class will be instantiated for one coin and will get all the relevant 
#          data to calculate each indicators, determine the BUY and SELL signals.
class CoinController():

    _binanceExchange = None
    _indicators = None
    _interval = None
    _ticker = None
    _base_currency = None
    _candle_data = None
    _current_price = None

    def __init__(self, interval, ticker, base_currency):

        try:
            self._interval = interval
            self._ticker = ticker
            self._base_currency = base_currency
            self._binanceExchange = BinanceExchangeManager()
            self._candle_data = self._binanceExchange.getTimeSeriesDataForTicker(self._ticker,self._base_currency, self._interval)
            self._indicators = Indicators(self._candle_data,self._interval)
            self._current_price = self._binanceExchange.getCrrentPriceForTicker(self._ticker, self._base_currency)['price']


        except Exception as e:
            print(f"Count not create Controller Object: {e}")
            raise Exception (f"Could not create Controller Object: {e}")

    
    def getEMASignal(self, short_period=12,long_period=26, threshold=0.03):
        ##
        # PURPOSE: This function will check for the conditions of EMA indicators. The algorithm is as follows:
        # INPUT : Threshold
        # OUTPUT: BUY, SELL or NEUTRAL
        #         If the current short-term EMA is greater than the current long-term EMA and the previous short-term EMA is within the threshold to the previous long-term EMA, then it's a BUY signal.
        #         If the current short-term EMA is less than the current long-term EMA and the previous short-term EMA is within the threshold to the previous long-term EMA, then it's a SELL signal.
        ##

        try:
            # Get Short term and Long term EMAs
            short_ema = self._indicators.calculate_ema(short_period)
            long_ema = self._indicators.calculate_ema(long_period)

            # Ensure that the data is sorted by timestamp
            short_ema = sorted(short_ema, key=lambda x: x['t'])
            long_ema = sorted(long_ema, key=lambda x: x['t'])

            # Extracting the last two data points
            current_short_ema = short_ema[-1]['ema']
            previous_short_ema = short_ema[-2]['ema']
            current_long_ema = long_ema[-1]['ema']
            previous_long_ema = long_ema[-2]['ema']

            # Checking for BUY Signal
            if (current_short_ema > current_long_ema and 
                current_short_ema >= (1 + threshold) * current_long_ema and 
                previous_short_ema <= previous_long_ema):
                return 'BUY'
            
            # Checking for SELL Signal
            if (current_short_ema < current_long_ema and current_short_ema <= (1 - threshold) * current_long_ema and previous_short_ema >= previous_long_ema):
                return 'SELL'
            
            # If neither condition is satisfied, then it's NEUTRAL
            return 'NEUTRAL'

        except Exception as e:
            print(f"getEMASignal(): {e}")
            raise Exception(f"Error getting EMA Signals: {e}")
        

    def getRSI_Signal(self):
        ##
        # PURPOSE: This function will look at the RSI data and determine a buy or sell signal.
        # Algorithm: BUY Signal if RSI is below 25
        #            SELL Signal if RSI is above 70
        # INPUT: None
        # OUTPUT: BUY, SELL or NEUTRAL

        try:
            # Get rsi data
            rsi_data = self._indicators.calculate_rsi(14)
            # Ensure that the data is sorted by timestamp
            rsi_data = sorted(rsi_data, key=lambda x: x['t'])

            # Extracting the last RSI data point
            current_rsi = rsi_data[-1]['rsi']

            # BUY signal criteria
            if current_rsi < 25:
                return 'BUY'

            # SELL signal criteria
            elif current_rsi > 70:
                return 'SELL'

            # Otherwise, it's neutral
            return 'NEUTRAL'
        except Exception as e:
            print(f"getRSI_Signal(): {e}")
            raise Exception(f"Could not get RSI signal: {e}")
        

    def getVolumeSignal(self, lookback=10):
        ###
        # PURPOSE: This function will look at the volume and determine an uptrend or downtrend
        # Algorithm: BUY Signal if the volume is uptrend
        #            SELL Signal if the volume is downtrend
        # INPUT: lookback is the number of previous datapoints to look at to determine trend
        # OUTPUT: BUY, SELL or NEUTRAL
        
        try:
            # Get volume data
            volume_data = self._indicators.calculate_volume_ema(14)

            # Ensure that the data is sorted by timestamp
            volume_data = sorted(volume_data, key=lambda x: x['t'])

            # Extracting volume EMA data for trend detection
            volume_values = np.array([item['volume_ema'] for item in volume_data[-lookback:]])
            x = np.arange(len(volume_values))

            # Calculate linear regression coefficients (slope and intercept)
            A = np.vstack([x, np.ones(len(x))]).T
            slope, intercept = np.linalg.lstsq(A, volume_values, rcond=None)[0]

            # Calculate the p-value using the t-statistic
            residuals = volume_values - (slope * x + intercept)
            rss = np.sum(residuals**2)
            t_stat = slope / (np.sqrt(rss / (len(x) - 2) / np.sum((x - np.mean(x))**2)))
            
            # Calculate the p-value using ECDF from statsmodels
            ecdf = ECDF(np.random.standard_t(len(x) - 2, size=10000))
            p_value = 2 * (1 - ecdf(abs(t_stat)))

            # BUY signal criteria (Uptrend in volume)
            if slope > 0 and p_value < 0.05:
                return 'BUY'
                
            # SELL signal criteria (Downtrend in volume)
            elif slope < 0 and p_value < 0.05:
                return 'SELL'

            # Otherwise, it's neutral
            return 'NEUTRAL'

        except Exception as e:
            print(f"getVolumeSignal(): {e}")
            raise Exception(f"Could not get Volume signal: {e}")
        
    def getBollingerSignal(self):
        ###
        # PURPOSE: This function will look at the bollinger bands and determine a BUY or SELL signal
        # Algorithm: BUY: If the price touches or dips below the lower band and then starts to rebound 
        #           (i.e., the current price is above the lower band and the previous price 
        #           was below or equal to the lower band).
        #           SELL: If the price touches or rises above the upper band and then starts to 
        #           reverse downward (i.e., the current price is below the upper band and the 
        #           previous price was above or equal to the upper band).
        # INPUT: lookback is the number of previous datapoints to look at to determine trend
        # OUTPUT: BUY, SELL or NEUTRAL

        try:
            bollinger_data = self._indicators.calculate_bollinder_bands()

            # Ensure that the data is sorted by timestamp
            bollinger_data = sorted(bollinger_data, key=lambda x: x['t'])

            # Extracting the latest Bollinger Bands data
            latest_data = bollinger_data[-1]
            upper_band = latest_data['upper_band']
            lower_band = latest_data['lower_band']

            current_price = float(self._current_price)
            previous_price = float(self._candle_data[-2]['c']) # get the previous price data

             # Buy criteria
            if previous_price <= lower_band and current_price > lower_band:
                return 'BUY'
            
             # Sell criteria
            elif previous_price >= upper_band and current_price < upper_band:
                return 'SELL'
            
            # Otherwise, it's neutral
            return 'NEUTRAL'
        
        except Exception as e:
            print(f"bollingerSignal(): {e}")
            raise Exception(f"Could not get bollinger signals: {e}")
