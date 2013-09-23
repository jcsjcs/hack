json.array!(@plant_types) do |plant_type|
  json.extract! plant_type, :name, :notes
  json.url plant_type_url(plant_type, format: :json)
end
