require 'httparty'
require 'json'


# Functions
# -------------------
def get_locations(base_url)
    begin
        print "¿En cuántas regiones quieres buscar? "
        n = Integer(gets.chomp)
        puts "\nBuscando en las primeras #{n} regiones...\n\n"
    rescue
        puts "\nPor favor ingresa un número"
        retry
    end

    response = HTTParty.get(base_url + '/regions')
    regions = JSON.parse(response.body)['regions'][0..n-1]
    regions = regions.map { |region| { name: region['name'], id: region['id'] } }
    
    locations = []
    regions.each do |region| # Get the locations for each region
        region = region[:name]
        response = HTTParty.get(base_url + '/region/' + region + '/locations.json')
        locations += JSON.parse(response.body)['locations'].map { |location| { id: location['id'], name: location['name'], num_machines: location['num_machines'] } }
    end

    return locations
end


def get_stats(locations, display_all_locations)
    # Calculate the stats
    total_machines = locations.map { |location| location[:num_machines] }.reduce(:+)
    average_machines = total_machines.to_f / locations.length
    max_machines = locations.max_by { |location| location[:num_machines] }
    min_machines = locations.min_by { |location| location[:num_machines] }
    
    if display_all_locations
        max_machines = locations.select { |location| location[:num_machines] == locations.max_by { |location| location[:num_machines] }[:num_machines] }
        min_machines = locations.select { |location| location[:num_machines] == locations.min_by { |location| location[:num_machines] }[:num_machines] }
        max_machines = max_machines.map { |location| location[:name] }
        min_machines = min_machines.map { |location| location[:name] }
    else
        max_machines = max_machines[:name]
        min_machines = min_machines[:name]
    end

    # Calculate the width of the * line
    lines = ["Estadísticas:", "*", "Cantidad de máquinas: #{total_machines}", "Promedio de máquinas: #{average_machines}", "Ubicación con mayor cantidad de máquinas: #{max_machines}", "Ubicación con menor cantidad de máquinas: #{min_machines}"]
    max_width = lines.max_by(&:length).length
    lines[1] = "*" * max_width

    return lines
end


# Main
# -------------------
if __FILE__ == $0
    display_all_locations = false  # If true, it will display all the locations with the same number of max and min machines instead of just one
    base_url = 'http://pinballmap.com/api/v1'

    locations = get_locations(base_url)
    stats = get_stats(locations, display_all_locations)
    puts stats
end
