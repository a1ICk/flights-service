# frozen_string_literal: true

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
  end
end
