# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'json'

class Service::Parser
  attr_accessor :airline_flights

  def initialize
    @airline_flights = []
  end

  def parse_airline(airline_icao_code)
    uri = URI("https://flight-data4.p.rapidapi.com/get_airline_flights?airline=#{airline_icao_code}")

    data = JSON.parse(Service::Parser.response(uri).read_body)

    data.each do |i|
      return unless i.is_a? Hash
      @airline_flights << i['flight']
    end

    p 'Success parse airlines'
  end

  def parse_flight
    if @airline_flights.empty?
      throw Exception.new 'Empty flights array'
    end
    error_count = 0

    @airline_flights.each do |flight|
      sleep(2)
      begin
        uri = URI("https://flight-data4.p.rapidapi.com/get_flight_info?flight=#{flight}")

        response = JSON.parse(Service::Parser.response(uri).read_body)[flight]

        arr_airport = response['arr_airport']
        dep_airport = response['dep_airport']

        distance = response['flight']['distance']
        correct_flight = Service::CorrectFlight.correct_flight_number(flight)
        new_flight = Flight.create(flight_number: correct_flight, distance: 0)

        arrival = Airport.create!(longitude: arr_airport['longitude'], latitude: arr_airport['latitude'], city: arr_airport['city'], iata: arr_airport['iata'], country: arr_airport['country'])
        departure = Airport.create!(longitude: dep_airport['longitude'], latitude: dep_airport['latitude'], city: dep_airport['city'], iata: dep_airport['iata'], country: dep_airport['country'])

        Route.create!(distance: distance, arrival_airport_id: arrival.id, departure_airport_id: departure.id, flight_id: new_flight.id)
      rescue Exception => ex
        error_count += 1
        p "#{ex.message}\n#{ex.cause}"
      ensure
        next
      end
    end

    p "Count errors while parsing flights: #{error_count}"
  end

  def self.response(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["X-RapidAPI-Key"] = ENV['RAPID_API_KEY']
    request["X-RapidAPI-Host"] = ENV['RAPID_API_HOST']

    http.request(request)
  end
end
