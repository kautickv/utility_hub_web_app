from Indicators import Indicators
from BinanceExchangeManager import BinanceExchangeManager
import matplotlib.pyplot as plt
from datetime import datetime
import pytz
import mplcursors
import matplotlib.dates as mdates

binanceExchange = BinanceExchangeManager()
data = binanceExchange.getTimeSeriesDataForTicker("BTC", "USDT", "6h")

# Convert Unix timestamp to CDT timezone
def convert_to_cdt(unix_timestamp):
    utc_time = datetime.utcfromtimestamp(unix_timestamp/1000)
    utc_time = pytz.utc.localize(utc_time)
    cdt_time = utc_time.astimezone(pytz.timezone("America/Chicago"))
    return cdt_time

def info(sel):
    date = mdates.num2date(sel.target[0])
    formatted_date = date.strftime('%Y-%m-%d %H:%M:%S')
    print(f"Time: {formatted_date}, Value: {sel.target[1]:.2f}")
    return (f"Time: {formatted_date}, Value: {sel.target[1]:.2f}")

def plotInitialPriceData(data,ema_12,ema_26,title, rsi_data, volume_ema):
    # Extracting 'c' and 't' values from the data
    closing_price = [float(item['c']) for item in data]
    time = [convert_to_cdt(item['t']) for item in data]

    # Extracting 'ema' and 't' values for ema_12
    ema_12_values = [item['ema'] for item in ema_12]
    ema_12_time = [convert_to_cdt(item['t']) for item in ema_12]

    # Extracting 'ema' and 't' values for ema_26
    ema_26_values = [item['ema'] for item in ema_26]
    ema_26_time = [convert_to_cdt(item['t']) for item in ema_26]

    # Extract "rsi" and "t" values for rsi_data
    rsi_values = [item['rsi'] for item in rsi_data]
    rsi_time = [convert_to_cdt(item['t']) for item in rsi_data]

    # Extract "volume_ema" and "t" values for volume_ema
    volume_values = [item['volume_ema'] for item in volume_ema]
    volume_time = [convert_to_cdt(item['t']) for item in volume_ema]

    fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(10, 10))  # 3 rows, 1 column

    # Plotting on the first axis
    ax1.plot(time, closing_price, marker='o', label='Closing Price')
    ax1.plot(ema_12_time, ema_12_values, label='EMA 12', color='red', linestyle='--')
    ax1.plot(ema_26_time, ema_26_values, label='EMA 26', color='blue', linestyle='--')
    ax1.set_xlabel('Time (CDT)')
    ax1.set_ylabel('Price')
    ax1.set_title(title)
    ax1.legend(loc='upper left')
    ax1.tick_params(axis='x', rotation=45)

    # Plotting on the second axis (You can add other data here)
    ax2.plot(volume_time, volume_values, label='Volume EMA', marker='o') 
    ax2.set_xlabel('Time')
    ax2.set_ylabel('Volume EMA')
    ax2.set_title('Volume EMA')

    # Plotting on the second axis (You can add other data here)
    ax3.plot(rsi_time, rsi_values, label='RSI', marker='o') 
    ax3.set_xlabel('Time')
    ax3.set_ylabel('RSI Value')
    ax3.set_title('RSI')

    # Tight layout to ensure labels don't get cut off
    plt.tight_layout()
    cursor1 = mplcursors.cursor(ax1, hover=True)
    cursor2 = mplcursors.cursor(ax2, hover=True)  
    cursor3 = mplcursors.cursor(ax3, hover=True) 
    cursor1.connect("add", info)
    cursor2.connect("add", info) 
    cursor3.connect("add", info) 

    plt.show()


print("starting")

# Create indicator class
indicator = Indicators(data,"1D")

#Calculating short and long term ema
ema_12 = indicator.calculate_ema(20)
ema_26 = indicator.calculate_ema(100)

# Calculating RSI
rsi_data = indicator.calculate_rsi(14)

# Getting the volume ema
volume_ema_data = indicator.calculate_volume_ema(14)

# Plot data
plotInitialPriceData(data,ema_12, ema_26, "BTC closing price vs time",rsi_data, volume_ema_data)



########################################################################
# testing BinanceExchangeManager


