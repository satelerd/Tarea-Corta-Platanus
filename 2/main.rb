# Escribe código en Ruby que use la API pinballmap y:

# Obtenga todas las ubicaciones para las primeras n regiones.

# Usando la información obtenida obtenga las siguientes estadísticas:
#   Cantidad total de máquinas.
#   Promedio de máquinas por ubicación.
#   Ubicación con mayor cantidad de máquinas.
#   Ubicación con menor cantidad de máquinas.

# Muestre por pantalla las estadísticas con el siguiente formato:
#   Estadísticas:
#   **************************************************
#   Cantidad de máquinas: [número]
#   Promedio de máquinas: [número]
#   Ubicación con mayor cantidad de máquinas: [nombre]
#   Ubicación con menor cantidad de máquinas: [nombre]

# Ten en cuenta que la línea de * tiene que tener el ancho del string más grande del reporte.

# -----------------------------------------------------------------------------

require 'httparty'
require 'json'

# Funciones
# -------------------
def get_locations(n, base_url) # Obtener las primeras n regiones
    response = HTTParty.get(base_url + '/regions')
    regions = JSON.parse(response.body)['regions'][0..n-1]
    regions = regions.map { |region| { name: region['name'], id: region['id'] } }
    
    locations = []
    regions.each do |region|
        region = region[:name]
        response = HTTParty.get(base_url + '/region/' + region + '/locations.json')
        locations += JSON.parse(response.body)['locations'].map { |location| { id: location['id'], name: location['name'], num_machines: location['num_machines'] } }
    end

    # puts "Hay #{regions.length} regiones"
    # puts regions.map { |region| region[:name] }
    return locations
end


def get_stats(locations)
    # Cantidad total de máquinas.
    total_machines = locations.map { |location| location[:num_machines] }.reduce(:+)
    # Promedio de máquinas por ubicación.
    puts "Hay #{total_machines} máquinas"
    puts "Hay #{locations.length} ubicaciones"
    average_machines = total_machines / locations.length
    # Ubicación con mayor cantidad de máquinas.
    max_machines = locations.max_by { |location| location[:num_machines] }
    # Ubicación con menor cantidad de máquinas.
    min_machines = locations.min_by { |location| location[:num_machines] }

    return {
        total_machines: total_machines,
        average_machines: average_machines,
        max_machines: max_machines,
        min_machines: min_machines
    }
end

def print_stats(stats, lines)
    # ten en cuenta que la línea de * tiene que tener el ancho del string más grande del reporte.
    # para lograr esto, debes calcular el ancho de cada string y luego tomar el máximo.
    #lines es una lista de strings
    max_length = lines.map { |line| line.length }.max
    puts "Estadísticas:"
    puts "*" * max_length
    puts "Cantidad de máquinas: #{stats[:total_machines]}"
    puts "Promedio de máquinas: #{stats[:average_machines]}"
    puts "Ubicación con mayor cantidad de máquinas: #{stats[:max_machines][:name]}"
    puts "Ubicación con menor cantidad de máquinas: #{stats[:min_machines][:name]}"
    
    puts "Estadísticas:"
end


# Llamadas de funciones
# -------------------
base_url = 'http://pinballmap.com/api/v1'

# lines = [
#     1st_line = "Estadísticas:",
#     2nd_line = "*",
#     3rd_line = "Cantidad de máquinas: ",
#     4th_line = "Promedio de máquinas: ",
#     5th_line = "Ubicación con mayor cantidad de máquinas: ",
#     6th_line = "Ubicación con menor cantidad de máquinas: "
# ]


locations = get_locations(2, base_url)
stats = get_stats(locations)
print_stats(stats, lines)



# Dudas
# -------------------
# Si hay varias ubicaciones con el mismo mayor o menor número de máquinas, las muestro todas?
