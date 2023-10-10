require 'rails_helper'

RSpec.describe Airport, type: :model do
  let(:arrival_airport) { create(:airport) }
  let(:first_route) { create(:route, arrival_airport: arrival_airport) }
  let(:second_route) { create(:route, arrival_airport: arrival_airport) }

  describe 'associations' do
    describe 'have many routes' do
      it { expect(first_route.arrival_airport).to eq(arrival_airport) }
      it { expect(second_route.arrival_airport).to eq(arrival_airport) }
    end
  end
end
