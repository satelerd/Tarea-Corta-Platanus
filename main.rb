# Entrevista Técnica Platanus
# 1. Calcular stats
# Crear un método simple llamado stats que reciba un arreglo de números. El método debe retornar un objeto con los siguientes elementos:

# size: el tamaño del array.
# avg: el promedio de los valores del array. Se calcula como la suma de todos los valores dividido en el total.
# sd: es la desviación estándar:
# https://wikimedia.org/api/rest_v1/media/math/render/svg/df695c81f11c7d0d27209a42c72c20d2ad4e1fd2

# max: el valor máximo de todos los elementos del array.
# median: el valor de la mediana, se calcula como el valor central del conjunto ordenado.
# min: el valor mínimo de todos los elementos del array.

require 'httparty'

def stats(array)
    size = array.size
    # avg as a float
    avg = array.inject(:+).to_f / size
    sd = Math.sqrt(array.inject(0) { |sum, x| sum + (x - avg)**2 } / size) # Revisar esto
    max = array.max
    min = array.min

    # posible bug! ---------------------
    if size % 2 == 0
        median = (array.sort[(size / 2) - 1] + array.sort[size / 2]) / 2.0    
    else
        median = array.sort[size / 2]
    end

    return { size: size, avg: avg, sd: sd, max: max, median: median, min: min }
end

# print stats = stats([3, 4, 5, 6, 3, 5, 7, 8, 9, 10, 2, 3])


# 2. API
# Usando la API sobre sismos de https://earthquake.usgs.gov/fdsnws/event/1/ crear un método llamado earthquakes_mag_stats(from_date, to_date) tal que reciba dos fechas.
# El método debe tomar las magnitudes de los eventos ocurridos entre esas dos fechas y retornar un objeto con los datos: size, avg, sd, max, median y min. Usa el método stats que creamos antes.

def earthquakes_mag_stats(from_date, to_date)
    url = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=%&endtime=$"
    url = url.gsub("$", to_date)
    url = url.gsub("%", from_date)

    response = HTTParty.get(url)
    puts resonse
    
end
earthquakes_mag_stats('2018-01-01', '2018-01-02')