json.array!(@hack_meets) do |hack_meet|
  json.extract! hack_meet, :hack_year, :hack_month, :hack_date, :start_time, :work_area, :notes, :hack_venue_id, :social, :hack_attendances_count
  json.url hack_meet_url(hack_meet, format: :json)
end
