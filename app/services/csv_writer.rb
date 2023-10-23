# frozen_string_literal: true
require 'csv'
require 'pry'
class Service::CSVWriter

  def self.write_line(csv, flight, flight_number, flight_number_to_lookup)
    if flight.nil?
      csv << [flight_number, flight_number_to_lookup, 'FAIL', nil, nil, nil, nil]
      return false
    end
    csv << [
      flight_number,
      flight.flight_number,
      'OK',
      flight.routes.size,
      flight.routes.first.departure_airport.iata,
      flight.routes.last.arrival_airport.iata,
      flight.distance
    ]

    true
  end

  def self.write(path)
    headers = ['Example flight number','Flight number used for lookup','Lookup status','Number of legs','First leg departure airport IATA','Last leg arrival airport IATA','Distance in kilometers']
    begin
      flights_list = get_all_flights(path)
      CSV.open(path, 'w', headers: true) do |csv|
        csv << headers

        flights_list.each do |line|

          flight_numbers = line.split(/[,;.\s]+/)
          flight_numbers.each do |flight_number|
            begin
              correct_flight_number = Service::CorrectFlight.correct_flight_number(flight_number)
              flight = Service::Parser.new(flight_iata: correct_flight_number[:flight_iata], flight_icao: correct_flight_number[:flight_icao]).find_flight

              flight_number_for_lookup = correct_flight_number.map { |_, v| v unless v.empty? }.compact[0]
              csv << [line, flight_number_for_lookup, 'FAIL', nil, nil, nil, nil] && next if flight.nil?

              self.write_line(csv, flight, line, flight_number)

            rescue Exception => ex
              p ex, line
            end
          end
        end
      end
    rescue Exception => ex
      return false
    end

    puts "Success write\n"
    return true
  end

  private
  def self.get_all_flights(path)
    flights_list = []
    table = CSV.table(path)
    table.each do |row|
      flights_list << row[0].to_s
    end

    flights_list
  end
end
