require_relative '../../app/services/service'
require_relative '../../app/services/parser'
require_relative '../../app/services/csv_writer'
require_relative '../../app/services/correct_flight'
namespace :batch do
  desc "Parse data and save into db"
  task parse_data: :environment do
    begin
      parser = Service::Parser.new
      parser.parse_airline('SIA')
      parser.parse_flight
    rescue Exception => ex
      puts "Error: #{ex.message}"
    end
  end

  desc "Write data into CSV file"
  task write_csv: :environment do
    Service::CSVWriter.write
  end
end
