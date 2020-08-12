require 'csv'

desc "export places as a CSV"
task :export_places => :environment do
  file = "data/places.csv"
  places = Place.sort(:compare).find_each()
  CSV.open( file, 'w' ) do |writer|
    writer << ['Label', 'Name', 'Identifier', 'GeoID', 'Lat', 'Long']
    places.each do |place|
      writer << [place.label, place.name, place.compare, place.geoid, place.coords[1], place.coords[0]]
    end
  end
end

desc "export results by group to JSON files"
task :export_results => :environment do
  counter = 0

  Group.find_each( :state.in => ['complete', 'active'] ) do |g|
    counter += 1
    puts "#{counter} #{g.zooniverse_id} #{g.name}"

    results = Timeline.sort(:page_number, :page_order).all(:group => g.zooniverse_id)
    File.open("data/results/#{g.zooniverse_id}.json", 'w') { |file| file.puts results.to_json }
  end
end

desc "export classified groups to JSON files"
task :export_groups => :environment do
  counter = 0

  Group.sort(:zooniverse_id).find_each( :state.in => ['complete', 'active'] ) do |g|
    counter += 1
    puts "#{counter} #{g.zooniverse_id} #{g.name}"

    File.open("data/groups/#{g.zooniverse_id}.json", 'w') { |file| file.puts g.to_json }
  end
end