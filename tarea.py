import time
import requests


# Funcion que llama al api de los trades y obtiene el valor maximo
def max_val(market_id):
    timestamp = int(time.time()) - 60 * 60 * 24     # Unix timestamp de hace 24hrs
    print(timestamp)

    url = f'https://www.buda.com/api/v2/markets/{market_id}/trades?limit=100'
    response = requests.get(url).json()

    # Loop para encontrar el valor maximo
    valor_maximo = 0
    for entrie in response["trades"]["entries"]:

        # Si ya pasaron las 24hrs terminar el loop
        if float(entrie[0]) < timestamp:
            print(float(entrie[0]))
            break

        if float(entrie[1]) > valor_maximo:
            valor_maximo = float(entrie[1])

    return valor_maximo


# api call de los markets
url_markets = 'https://www.buda.com/api/v2/markets'
response_markets = requests.get(url_markets).json()

# Loop para obtener todos los mercados y la transaccion de mayor valor
data = []
for market in response_markets["markets"]:
    data.append({
        "mercado": market["id"],
        "valor_maximo": max_val(market["name"])
    })
print(data)


# Generar la tabla de html


# import HTML
# py_table = [
#     ["Mercado", "Transacción de mayor valor"]
# ]

# for i in range(len(data)):
#     py_table.append([data[i]["mercado"], data[i]["valor_maximo"]])

# htmlcode = HTML.table(py_table)
# print(htmlcode)
