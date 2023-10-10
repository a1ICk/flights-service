# frozen_string_literal: true

require 'csv'

class Service::CSVWriter
  def self.write
    flights = Flight.includes(:routes)

      csv = CSV.open('flight_numbers.csv', 'a')

      flights.each do |flight|
        flight.routes.each do |route|
          csv << ['', flight.flight_number, 'OK', flight.routes.count, flight.routes.first.departure_airport.iata, flight.routes.last.arrival_airport.iata, flight.distance]
        end
      end

      p 'Success write in CSV'
  end
end
