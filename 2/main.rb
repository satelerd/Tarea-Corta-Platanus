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
def get_locations(base_url) # Obtener las primeras n regiones
    begin
        print "¿En cuántas regiones quieres buscar? "
        n = Integer(gets.chomp)
        puts ""
        puts "Buscando en las primeras #{n} regiones..."
        puts ""
    rescue
        puts ""
        puts "Porfavor ingresa un número"
        retry
    end

    response = HTTParty.get(base_url + '/regions')
    regions = JSON.parse(response.body)['regions'][0..n-1]
    regions = regions.map { |region| { name: region['name'], id: region['id'] } }
    
    # Separamos las regiones en ubicaciones
    locations = []
    regions.each do |region|
        region = region[:name]
        response = HTTParty.get(base_url + '/region/' + region + '/locations.json')
        locations += JSON.parse(response.body)['locations'].map { |location| { id: location['id'], name: location['name'], num_machines: location['num_machines'] } }
    end

    return locations
end


def get_stats(locations) # Obtener las estadísticas
    # Calculamos las estadísticas
    total_machines = locations.map { |location| location[:num_machines] }.reduce(:+)
    average_machines = total_machines.to_f / locations.length
    max_machines = locations.max_by { |location| location[:num_machines] }
    min_machines = locations.min_by { |location| location[:num_machines] }

    # Calculamos el ancho de la línea de *
    lines = ["Estadísticas:", "*", "Cantidad de máquinas: #{total_machines}", "Promedio de máquinas: #{average_machines}", "Ubicación con mayor cantidad de máquinas: #{max_machines[:name]}", "Ubicación con menor cantidad de máquinas: #{min_machines[:name]}"]
    max_width = lines.max_by(&:length).length
    lines[1] = "*" * max_width

    return lines
end


# Variables y llamadas de funciones
# -------------------
base_url = 'http://pinballmap.com/api/v1'


locations = get_locations(base_url)
stats = get_stats(locations)
puts stats


# Dudas
# -------------------
# Si hay varias ubicaciones con el mismo mayor o menor número de máquinas, las muestro todas?
