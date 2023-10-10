require 'rails_helper'

RSpec.describe Route, type: :model do
  let(:route) { build(:route) }
  let(:flight) { create(:flight, :routes => [route]) }

  describe 'associations' do
    it 'belong to flight' do
      expect(route).to belong_to(:flight)
    end

    it 'belong to departure airport' do
      expect(route).to belong_to(:departure_airport)
    end

    it 'belong to arrival airport' do
      expect(route).to belong_to(:arrival_airport)
    end
  end

  describe '#save' do
    let!(:old_distance) { flight.distance }

    it 'changes flight distance' do
      route.save
      expect(flight.distance).to eq(old_distance + route.distance)
    end
  end

end
