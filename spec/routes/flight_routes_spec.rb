require 'rails_helper'

RSpec.describe 'Flight routes', type: :routing do
  let(:flight) { create(:flight) }

  it 'routes flight path to flights#show' do
    expect(get: "/flight/#{flight.id}").to route_to(controller: 'flights', action: 'show', flight_number: flight.id.to_s)
  end
end
