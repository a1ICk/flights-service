class Route < ApplicationRecord
  belongs_to :departure_airport, class_name: 'Airport', foreign_key: 'departure_airport_id'
  belongs_to :arrival_airport, class_name: 'Airport', foreign_key: 'arrival_airport_id'
  belongs_to :flight

  after_save :update_flight_distance

  private

  def update_flight_distance
    self.flight.distance += self.distance

    self.flight.save
  end
end
