# frozen_string_literal: true

class RouteSerializer
  include JSONAPI::Serializer

  attributes :distance

  belongs_to :arrival_airport, serializer: AirportSerializer
  belongs_to :departure_airport, serializer: AirportSerializer
end
