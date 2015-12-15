json.array!(@locations) do |location|
  json.extract! location, :id, :address, :longitude, :latitude
  json.url location_url(location, format: :json)
end
