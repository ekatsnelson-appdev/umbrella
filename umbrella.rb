p "Hi! Where are you located?"

user_location = gets.chomp


p user_location


gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=AIzaSyAgRzRHJZf-uoevSnYDTf08or8QFS_fb3U"

require "open-uri"

raw_data = URI.open(gmaps_url).read

require "json"

parsed_data = JSON.parse(raw_data)

results = parsed_data.fetch("results")

first_result = results.at(0)

geo = first_result.fetch("geometry")

loc = geo.fetch("location")

latitude = loc.fetch("lat")
longitude = loc.fetch("lng")




# Use Latitude and Longitude for Dark Sky API

dark_sky_token = ENV.fetch("DARK_SKY_TOKEN")
dark_sky_url = "https://api.darksky.net/forecast/" + dark_sky_token + "/" + latitude.to_s + "," + longitude.to_s

raw_ds_data = URI.open(dark_sky_url).read
ds_parsed_data = JSON.parse(raw_ds_data)


current_temp = ds_parsed_data.fetch("currently").fetch("temperature")
p "The current temperature is: " + current_temp.to_s + " degrees F"

hourly_data_array = ds_parsed_data.fetch("hourly").fetch("data")
next_hour_weather = hourly_data_array[1].fetch("summary")
p "The weather in the next hour will be: " + next_hour_weather

# Check next 12 hours if precipitation probability is greater than 10%


next_twelve_hours = hourly_data_array[1..12]
will_rain = false # starting with assumption of no rain

next_twelve_hours.each do |this_hour_hash|
  rain_prob = this_hour_hash.fetch("precipProbability")
  if rain_prob > 0.10
    will_rain = true
    break
  end
end

if will_rain
  p "You might want to carry an umbrella!"
else
  p "You probably won't need an umbrella today."
end
