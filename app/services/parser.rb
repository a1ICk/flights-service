# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'json'

class Service::Parser
  attr_accessor :flight_iata, :flight_icao
  def initialize(flight_iata: '', flight_icao: '')
    @flight_iata = flight_iata
    @flight_icao = flight_icao
  end

  def find_flight
    flight = Flight.includes(:routes).find_by(flight_number: @flight_iata) || Flight.includes(:routes).find_by(flight_number: @flight_icao)

    return flight unless flight.nil?

    if (@flight_iata + @flight_icao).empty?
      throw Exception.new 'Both flight_iata and flight_icao can not be empty'
    end

    url = ''
    if @flight_icao.empty?
      url = "https://airlabs.co/api/v9/flight?flight_iata=#{@flight_iata}&api_key=#{ENV['AIRLABS_API_KEY']}"
    else
      url = "https://airlabs.co/api/v9/flight?flight_icao=#{@flight_icao}&api_key=#{ENV['AIRLABS_API_KEY']}"
    end

    response_data = Service::Parser.response(url)['response']
    if response_data&.empty? || response_data.nil?
      return nil
    end

    arrival_airport_iata = response_data['arr_iata']
    departure_airport_iata = response_data['dep_iata']

    if @flight_icao.empty?
      flight = Flight.create!(flight_number: @flight_iata, distance: 0)
    else
      flight = Flight.create!(flight_number: @flight_icao, distance: 0)
    end

    departure = Service::Parser.find_airport_by_iata(departure_airport_iata)
    arrival = Service::Parser.find_airport_by_iata(arrival_airport_iata)

    distance = Service::Parser.calculate_distance(departure.latitude, departure.longitude, arrival.latitude, arrival.longitude)

    Route.create!(
      distance: distance,
      departure_airport_id: departure.id,
      arrival_airport_id: arrival.id,
      flight_id: flight.id
    )

    flight
  end


  private

  def self.find_airport_by_iata(airport_iata)
    url = "https://airlabs.co/api/v9/airports?iata_code=#{airport_iata}&api_key=#{ENV['AIRLABS_API_KEY']}"

    data = Service::Parser.response(url)['response'][0]

    Airport.create!(
      iata: data['iata_code'],
      city: data['city'],
      country: data['country_code'],
      latitude: data['lat'],
      longitude: data['lng']
    )
  end

  def self.calculate_distance(dep_lat, dep_lon, arr_lat, arr_lon)
    earth_radius = 6371

    lat1_rad = self.to_rad(dep_lat)
    lon1_rad = self.to_rad(dep_lon)
    lat2_rad = self.to_rad(arr_lat)
    lon2_rad = self.to_rad(arr_lon)

    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad

    a = Math.sin(dlat/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon/2)**2
    c = 4 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    (earth_radius * c).round(2)
  end

  def self.to_rad(degree)
    (degree * (Math::PI/180)).round(2)
  end

  def self.response(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)

    response = http.request(request)

    JSON.parse(response.read_body)
  end
end
