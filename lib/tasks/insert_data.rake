namespace :app do
  require 'csv'

  task :insert_data, [:path] => :environment do |_task, args|
    csv_text = File.read(args[:path])
    csv = CSV.parse(csv_text, :headers => true, :col_sep => ';')
    csv.each do |row|
      Trip.create!(row.to_hash)
    end
  end

end
