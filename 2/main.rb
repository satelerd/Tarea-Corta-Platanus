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

    puts "Estadísticas:"
    puts "*"
    puts "Cantidad de máquinas: #{total_machines}"
    puts "Promedio de máquinas: #{average_machines}"
    puts "Ubicación con mayor cantidad de máquinas: #{max_machines[:name]}"
    puts "Ubicación con menor cantidad de máquinas: #{min_machines[:name]}"
end

# Llamadas de funciones
# -------------------
base_url = 'http://pinballmap.com/api/v1'

locations = get_locations(100, base_url)
get_stats(locations)




# Dudas
# -------------------
# Si hay varias ubicaciones con el mismo mayor o menor número de máquinas, las muestro todas?
