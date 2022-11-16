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

# Variables estaticas
# -------------------
base_url = 'http://pinballmap.com/api/v1'

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


# Llamadas de funciones
# -------------------
locations = get_locations(10, base_url)