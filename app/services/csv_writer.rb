# frozen_string_literal: true
require 'csv'

class Service::CSVWriter

  def self.write_line(csv, flight, flight_number)
    if flight.nil?
      csv << [flight_number, nil, 'FAIL', nil, nil, nil, nil]
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

        flights_list.each do |flight_number|

          begin
            correct_flight_number = Service::CorrectFlight.correct_flight_number(flight_number)
            flight = Service::Parser.new(flight_iata: correct_flight_number[:flight_iata], flight_icao: correct_flight_number[:flight_icao]).find_flight

            self.write_line(csv, flight, flight_number)
          rescue Exception => ex
            csv << [flight_number, nil, 'FAIL', nil, nil, nil, nil]
          end
        end
      end
    rescue Exception => ex
      p ex
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
