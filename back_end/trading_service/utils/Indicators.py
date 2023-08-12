
class Indicators():

    crypto_data = None
    timeframe = None

    def __init__(self, data, timeframe):
        # Data is an array of time series candlestick data.
        # It contains:
        # t - end time of candlestick (unix timestap)
        # o - Open price
        # h - High price
        # l - Low price
        # c - Close price
        # v - Volume in crypto terms

        # timeframe indicates the length of each candlestick. E.g 5m,1D,etc..
        self.crypto_data = data
        self.timeframe = timeframe


    def calculate_ema(self, period):

        ##
        # PURPOSE: This function will compute the Exponential Moving Average based on the number of period specified
        # INPUT: The number of period
        # OUTPUT: An array with the exponential moving average
        
        try:
            closing_prices = [float(item['c']) for item in self.crypto_data]
    
            # Ensure we have enough data
            if len(closing_prices) < period:
                raise ValueError("Not enough data to calculate EMA")

            # Start with a simple moving average for the initial EMA value
            ema_values = [sum(closing_prices[:period]) / period]
            
            multiplier = 2 / (period + 1)

            # Calculate the EMA values
            for i in range(period, len(closing_prices)):
                ema_today = (closing_prices[i] - ema_values[-1]) * multiplier + ema_values[-1]
                ema_values.append(ema_today)
            
            # Extracting timestamps starting from the 'period' to match the EMA values.
            timestamps = [entry['t'] for entry in self.crypto_data][period-1:]
            
            # Pairing EMA values with their associated timestamps
            ema_with_time = [{'t': timestamp, 'ema': ema} for timestamp, ema in zip(timestamps, ema_values)]
            
            return ema_with_time
        except Exception as e:
            print(f"calculate_ema():{e}")
            raise Exception(f"Error: {e}")