# frozen_string_literal: true

require_relative '../services/service'
require_relative '../services/correct_flight'
require_relative '../services/parser'

class FlightsController < ApplicationController
  before_action :set_flight

  def show
    if @flight
      render json: FlightSerializer.new(@flight, include: %w[routes.arrival_airport routes.departure_airport], params: { status: 'OK', error_message: nil }).serializable_hash, status: :ok
    else
      render json: {
        routes: @flight,
        status: :fail,
        distance: 0,
        error_message: 'Unable to find flight'
      }, status: :not_found
    end
  end

  private

  def set_flight
    @flight = Flight.includes(:routes).find_by(flight_number: params[:flight_number])
    if @flight.nil?
      flight_number = Service::CorrectFlight.correct_flight_number(params[:flight_number])

      @flight = Service::Parser.new(flight_iata: flight_number[:flight_iata], flight_icao: flight_number[:flight_icao]).find_flight
    end
  end
end
