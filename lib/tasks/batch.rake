require_relative '../../app/services/service'
require_relative '../../app/services/parser'
require_relative '../../app/services/csv_writer'
require_relative '../../app/services/correct_flight'
require 'active_record'

namespace :batch do
  desc "Write data into CSV file"
  task write_csv: :environment do
    Service::CSVWriter.write('flight_numbers.csv')
  end
end
