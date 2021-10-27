require 'httparty'


# Function that calls the trades api and obtains the maximum value
def max_val(market_id)
  trades = []
  timestamp_now = Time.now.to_i * 1000
  timestamp_24hrs = (Time.now.to_i - (60 * 60 * 24)) * 1000

  url = "https://www.buda.com/api/v2/markets/#{market_id}/trades?timestamp=#{timestamp_now}"
  response = HTTParty.get(url)
  response = JSON.parse(response.body)
  trades.push(response['trades']['entries'])

  # Check if there are 24hrs of trades and if not, make another request
  while response['trades']['last_timestamp'].to_i > timestamp_24hrs
    url = "https://www.buda.com/api/v2/markets/#{market_id}/trades?timestamp=#{response['trades']['last_timestamp'].to_i}"
    response = HTTParty.get(url)
    response = JSON.parse(response.body)
    trades.push(response['trades']['entries'])
  end

  puts "Trades: #{trades}"

  # Loop to find the maximum value
  max_value = 0
  response['trades']['entries'].each do |entrie|
    if entrie[0].to_i < timestamp_24hrs
      break
    end

    amount = entrie[1].to_f
    price = entrie[2].to_f
    value = amount * price

    max_value = value if value > max_value
  end

  max_value
end

# Get a list of all the markets and its maximum value
url_markets = 'https://www.buda.com/api/v2/markets'
response_markets = HTTParty.get(url_markets)
response_markets = JSON.parse(response_markets.body)

data = []
response_markets['markets'].each do |market|
  data.append({ 'market' => market['id'], 'maximum_value' => max_val(market['name']) })
end

# Generate the HTML table
html_table = "<table>\n"
html_table += "    <tr>\n"
html_table += "        <th>Market</th>\n"
html_table += "        <th>Higher value transaction</th>\n"
html_table += "    </tr>\n"

data.each do |market|
  html_table += "    <tr>\n"
  html_table += "        <td>#{market['market']}</td>\n"
  html_table += "        <td>#{market['maximum_value']}</td>\n"
  html_table += "    </tr>\n"
end
html_table += "</table>\n"

puts html_table
