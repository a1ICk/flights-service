# frozen_string_literal: true

class AirportSerializer
  include JSONAPI::Serializer

  attributes :longitude, :latitude, :iata, :city, :country
end
