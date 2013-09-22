json.array!(@hack_venues) do |hack_venue|
  json.extract! hack_venue, :venue, :notes
  json.url hack_venue_url(hack_venue, format: :json)
end
