require 'csv'

desc "export diaries as CSVs"
task :export_diaries => :environment do
  counter = 0
  groups = []
  Group.find_each( :state.in => ['complete', 'active'] ) do |g|
    groups << g
  end

  groups.each do |g|
    counter += 1
    puts "#{counter} #{g.zooniverse_id} #{g.name}"
    timeline = []
    Timeline.sort( :page_number, :page_order ).find_each( :group => g.zooniverse_id ) do |t|
      timeline << t
    end

    timeline = timeline.select{ |t| t['count'] >= 2 }

    column_names = [
      'Order',
      'Page',
      'Page type',
      'Page number',
      'Count',
      'DateTime',
      'Date',
      'Place',
      'Lat/Lon',
      'Time',
      'Type',
      'Label',
      'Data',
      'GeoID',
      'GeoName',
      'GeoCoords'
    ]

    CSV.open( "data/diaries/#{g.zooniverse_id}.csv", 'w' ) do |writer|
       writer << column_names
       place_cache = {}
       timeline.each do |t|

         unless place_cache.has_key? t['place']
           place_cache[ t['place'] ] = []
           Place.find_each( :label => t['place'] ) do |p|
             place_cache[ t['place'] ] << {:id => p['geoid'], :name => p['name'], :coords => p['coords'] }
           end
         end

         place_cache[ t['place'] ].each do |p|
           t["geoid"] = p[:id]
           t['geoname'] = p[:name]
           t['geocoords'] = p[:coords]
         end

         writer << [
           t["page_order"],
           t["page"],
           t["page_type"],
           t["page_number"],
           t["count"],
           t['datetime'],
           t['date'],
           t['place'],
           t['coords'].to_s,
           t['time'],
           t["type"],
           t['label'],
           t['votes'],
           t['geoid'],
           t['geoname'],
           t['geocoords']
         ]
       end
    end
  end
end

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