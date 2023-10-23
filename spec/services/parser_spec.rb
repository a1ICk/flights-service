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

    it { expect(radians).to eq(0.5235987755982988) }
  end

  describe '#calculate_distance' do
    let(:distance) { described_class.calculate_distance(52.16575, 20.96712, 50.07617, 19.79157) }

    it { expect(distance).to eq(123.2) }
  end

  describe '#response' do
    context 'when parse airport' do
      let(:response) {
        VCR.use_cassette("parser/airport") {
          described_class.response("https://airlabs.co/api/v9/airports?iata_code=CDG&api_key=#{ENV['AIRLABS_API_KEY']}")
        }
      }

      it 'shows airport by CDG IATA code' do
        expect(response).to be_instance_of Hash
        expect(response).to have_key('response')
        expect(response).to have_key('request')
        expect(response).to have_key('terms')
      end

      it 'has correct IATA airport code' do
        expect(response['response'][0]['iata_code']).to eq('CDG')
      end
    end

    context 'when parse flight' do
      let(:response) {
        VCR.use_cassette("parser/flight") {
          described_class.response("https://airlabs.co/api/v9/flight?flight_iata=LO4&api_key=#{ENV['AIRLABS_API_KEY']}")
        }
      }

      it 'shows flight by LO4 IATA code' do
        expect(response).to be_instance_of Hash
        expect(response).to have_key('response')
        expect(response).to have_key('request')
        expect(response).to have_key('terms')
      end

      it 'has correct IATA flight code' do
        expect(response['response']['flight_iata']).to eq('LO4')
      end
    end
  end

  describe "#find_airport_by_iata" do
    let(:airport) { described_class.find_airport_by_iata('CDG') }

    it { expect(airport).to be_instance_of Airport }
  end
end