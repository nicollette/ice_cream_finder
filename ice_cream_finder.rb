require 'rest-client'
require 'addressable/uri'
require 'JSON'
require 'nokogiri'

puts "Enter your address"
current_address = "1061 Market St San Francisco, CA"
geocode_link = Addressable::URI.new(
  :scheme => "http",
  :host => "maps.googleapis.com",
  :path => "maps/api/geocode/json",
  :query_values => {:address => current_address, :sensor => false}
  )
response = RestClient.get(geocode_link.to_s)
response = JSON.parse(response)

results = response["results"].first
geometry = results["geometry"]
location = geometry["location"]
location_values = location.values.join(',')
location

places_link = Addressable::URI.new(
  :scheme => "https",
  :host => "maps.googleapis.com",
  :path => "maps/api/place/nearbysearch/json",
  :query_values => { :key => "AIzaSyB_xwmb_GWvgSR2SEFa1RWRszreeRSMt1s",
                     :location => location_values,
                     :sensor => false,
                     :radius => 3000,
                     :keyword => "ice cream"
                   }
)

places_response = RestClient.get(places_link.to_s)

ice_cream_shop = JSON.parse(places_response)["results"].first
ice_cream_shop_location = ice_cream_shop["geometry"]["location"]
ice_cream_shop_loc_values = ice_cream_shop_location.values.join(',')

directions_link = Addressable::URI.new(
  :scheme => "http",
  :host => "maps.googleapis.com",
  :path => "maps/api/directions/json",
  :query_values => {:origin => location_values,
                    :destination => ice_cream_shop_loc_values,
                    :sensor => false,
                    :mode => "walking"
                    }
  )

directions_response = RestClient.get(directions_link.to_s)

routes = JSON.parse(directions_response)["routes"]



html_instructions = []
routes.each do |route|
  route["legs"].each do |leg|
    leg["steps"].each do |step|
      html_instructions << step["html_instructions"]
    end
  end
end

puts html_instructions

complete_instructions = html_instructions.map do |instruction|
  Nokogiri::HTML(instruction)
end

p complete_instructions.join(", ")
























# legs.each do |key, val|
#
#   puts "#{key} #{val}"
#   puts
# end