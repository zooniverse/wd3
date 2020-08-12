desc "export classified groups to JSON files"
task :export_groups => :environment do
  counter = 0

  Group.sort(:zooniverse_id).find_each( :state.in => ['complete', 'active'] ) do |g|
    counter += 1
    puts "#{counter} #{g.zooniverse_id} #{g.name}"

    File.open("data/groups/#{g.zooniverse_id}.json", 'w') { |file| file.puts g.to_json }
  end
end