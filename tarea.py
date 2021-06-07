import time
import requests

# Funcion que llama al api de los trades y obtiene el valor maximo
def max_val(market_id):
    url = f'https://www.buda.com/api/v2/markets/{market_id}/trades?limit=100'
    response = requests.get(url).json()

    # Loop para encontrar el valor maximo
    valor_maximo = 0
    timestamp_24hrs = int(time.time()) - 60*60*24     # Unix timestamp de hace 24hrs
    for entrie in response["trades"]["entries"]:
        # Si ya pasaron las 24hrs terminar el loop
        if float(entrie[0]) < timestamp_24hrs:
            print(float(entrie[0]))
            break
        
        amount = float(entrie[1])
        price = float(entrie[2])
        valor = amount * price

        if valor > valor_maximo:
            valor_maximo = valor

    return valor_maximo


# Api call de los markets
url_markets = 'https://www.buda.com/api/v2/markets'
response_markets = requests.get(url_markets).json()

# Loop para obtener todos los mercados y la transaccion de mayor valor
data = []
for market in response_markets["markets"]:
    data.append({
        "mercado": market["id"],
        "valor_maximo": max_val(market["name"])
    })


# Tabla HTML
tabla_HTML = """
<table>
    <tr>
        <th>Market</th>
        <th>Transaccion de mayor valor</th>
    </tr>

"""

for market in data:
    tabla_HTML += f"""    <tr>
        <td>{market["mercado"]}</td>
        <td>{market["valor_maximo"]}</td>
    </tr>
"""

tabla_HTML += """</table>
"""

print(tabla_HTML)
