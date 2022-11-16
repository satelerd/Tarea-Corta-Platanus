import time
import requests


# Function that calls the trades api and obtains the maximum value
def max_val(market_id):
    timestamp_24hrs = (int(time.time()) - (60 * 60 * 24)) * 1000

    url = f"https://www.buda.com/api/v2/markets/{market_id}/trades?timestamp={timestamp_24hrs}"
    response = requests.get(url).json()

    # Loop to find the maximum value
    max_value = 0
    for entrie in response["trades"]["entries"]:
        amount = float(entrie[1])
        price = float(entrie[2])
        value = amount * price

        if value > max_value:
            max_value = value

    return max_value


# Api call for the markets
url_markets = "https://www.buda.com/api/v2/markets"
response_markets = requests.get(url_markets).json()

# Loop to get all the markets and the highest value transaction
data = []
for market in response_markets["markets"]:
    data.append({"mercado": market["id"], "valor_maximo": max_val(market["name"])})


# Generate the HTML table
HTML_table = """
<table>
    <tr>
        <th>Market</th>
        <th>Transaccion de mayor valor</th>
    </tr>

"""

for market in data:
    HTML_table += f"""    <tr>
        <td>{market["mercado"]}</td>
        <td>{market["valor_maximo"]}</td>
    </tr>
"""

HTML_table += """</table>
"""

print(HTML_table)
