require 'rails_helper'
require_relative '../../app/services/service'
require_relative '../../app/services/parser'

RSpec.describe Service::Parser do
  describe '#find_flight' do
    context 'when given empty parameters' do
      let(:flight) { described_class.new(flight_iata: '', flight_icao: '') }

      it 'throws error' do
        expect { flight.find_flight }.to raise_exception(Exception)
      end
    end

    context 'when given incorrect code' do
      let(:new_flight) { described_class.new(flight_iata: '224', flight_icao: '') }

      it 'expect nil' do
        expect(new_flight.find_flight).to be_nil
      end
    end

    context 'when given flight iata code' do
      let!(:new_flight) { described_class.new(flight_iata: 'AY1983', flight_icao: '') }
      let(:flight) { new_flight.find_flight }

      it 'returns flight' do
        expect(flight).to be_instance_of Flight
      end
    end

    context 'when given flight icao code' do
      let!(:new_flight) { described_class.new(flight_iata: '', flight_icao: 'VIV2204') }

      it 'returns flight' do
        expect(new_flight.find_flight).to be_instance_of Flight
      end
    end
  end

  describe '#to_rad' do
    let(:radians) { described_class.to_rad(30) }

    it { expect(radians).to eq(0.52) }
  end

  describe '#calculate_distance' do
    let(:distance) { described_class.calculate_distance(43.412938, -80.4771472, 43.653226, -79.3831843) }

    it { expect(distance).to eq(92.36) }
  end

  describe '#response' do
    let(:response) { described_class.response('https://jsonplaceholder.typicode.com/todos/1') }

    it { expect(response).to be_instance_of Hash }
  end

  describe "#find_airport_by_iata" do
    let(:airport) { described_class.find_airport_by_iata('CDG') }

    it { expect(airport).to be_instance_of Airport }
  end
end