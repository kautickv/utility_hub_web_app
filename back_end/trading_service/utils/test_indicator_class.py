from Indicators import Indicators
from BinanceExchangeManager import BinanceExchangeManager
import matplotlib.pyplot as plt
from datetime import datetime
import pytz
import mplcursors
import matplotlib.dates as mdates

binanceExchange = BinanceExchangeManager()
data = binanceExchange.getTimeSeriesDataForTicker("BTC", "USDT", "15m")

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

def plotInitialPriceData(data,ema_12,ema_26,title):
    # Extracting 'c' and 't' values from the data
    closing_price = [float(item['c']) for item in data]
    time = [convert_to_cdt(item['t']) for item in data]

    # Extracting 'ema' and 't' values for ema_12
    ema_12_values = [item['ema'] for item in ema_12]
    ema_12_time = [convert_to_cdt(item['t']) for item in ema_12]

    # Extracting 'ema' and 't' values for ema_26
    ema_26_values = [item['ema'] for item in ema_26]
    ema_26_time = [convert_to_cdt(item['t']) for item in ema_26]

    # Plotting
    plt.figure(figsize=(10, 5))

    # Plot the original closing prices
    plt.plot(time, closing_price, marker='o', label='Closing Price')

    # Plot EMA 12
    plt.plot(ema_12_time, ema_12_values, label='EMA 12', color='red', linestyle='--')

    # Plot EMA 26
    plt.plot(ema_26_time, ema_26_values, label='EMA 26', color='blue', linestyle='--')

    # Labelling axes
    plt.xlabel('Time (CDT)')
    plt.ylabel('Price')
    plt.title(title)

    # Add legend to differentiate between lines
    plt.legend(loc='upper left')

    # Rotating x-axis labels for better readability
    plt.xticks(rotation=45)

    # Tight layout to ensure labels don't get cut off
    plt.tight_layout()

    cursor = mplcursors.cursor(hover=True)
    cursor.connect("add", info)

    # Displaying the plot
    plt.show()

print("starting")

# Create indicator class
indicator = Indicators(data,"1D")

ema_12 = indicator.calculate_ema(12)

ema_26 = indicator.calculate_ema(26)

# Plot data
plotInitialPriceData(data,ema_12, ema_26, "BTC closing price vs time")



########################################################################
# testing BinanceExchangeManager


