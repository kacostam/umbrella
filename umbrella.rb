# Write your solution here!

require "http"
require "json"
require "dotenv/load"

# retrieve location from the user
puts "hi! where are you located"
user_location = gets.chomp # asks user for location
puts "checking the weather at #{user_location}. . ."


# hidden variableS
pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY") 
google_maps_api_key = ENV.fetch("GMAPS_KEY")


# retrieve longitude and latitude from google maps
google_maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + google_maps_api_key

google_raw_response = HTTP.get(google_maps_url) # Place a GET request to the URL

google_parsed_response = JSON.parse(google_raw_response) # parse response to find longitude and latitude

results_array = google_parsed_response.fetch("results")
first_result_hash = results_array.at(0)
geometry_hash = first_result_hash.fetch("geometry")
location_hash = geometry_hash.fetch("location")

lat = location_hash.fetch("lat")
long = location_hash.fetch("lng")

# prints latitude and longitude to check
puts "latitude: #{lat.to_s}, longitude #{long.to_s} . . ."

# retrieve information from Pirate Weather

pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_api_key + "/" + lat.to_s + "," + long.to_s

pirate_weather_raw_response = HTTP.get(pirate_weather_url)

pirate_weather_parsed_response = JSON.parse(pirate_weather_raw_response)

currently_hash = pirate_weather_parsed_response.fetch("currently") # extract current weather data
current_precipitation_prob = currently_hash.fetch("precipProbability") # current precipitation probability

if current_precipitation_prob == 0.0
  puts "you don't need an umbrella right now :)"
else 
  puts "bring an umbrella with you!"
end
