require 'rails_helper'
require_relative '../../app/services/service'
require_relative '../../app/services/correct_flight'

RSpec.describe Service::CorrectFlight do
  describe "#flight_number_type" do
    context 'when icao' do
      let(:flight_number) { described_class.flight_number_type('YYYZZZZ') }

      it { expect(flight_number).to eq(:icao) }
    end

    context 'when icao' do
      let(:flight_number) { described_class.flight_number_type('XXZZZZ') }

      it { expect(flight_number).to eq(:iata) }
    end

    context 'throws exception' do
      let(:flight_number) { described_class.flight_number_type('WWWWZZZZ') }

      it { expect { flight_number }.to raise_exception Exception }
    end
  end

  describe '#correct_carrier_iata_code' do
    context 'when correct iata code' do
      let(:code) { described_class.correct_carrier_iata_code('XX') }

      it { expect(code).to be_truthy }
    end
    
    context 'when incorrect iata code' do
      let(:code) { described_class.correct_carrier_iata_code('X_') }

      it { expect(code).to be_falsey }
    end

    context "when exception" do
      let(:code) { described_class.correct_carrier_iata_code('XXX') }

      it { expect { code }.to raise_exception Exception }
    end
  end

  describe '#correct_carrier_icao_code' do
    context 'when correct icao code' do
      let(:code) { described_class.correct_carrier_icao_code('YYY') }

      it { expect(code).to be_truthy }
    end

    context 'when incorrect icao code' do
      let(:code) { described_class.correct_carrier_icao_code('Y_Y') }

      it { expect(code).to be_falsey }
    end

    context "when exception" do
      let(:code) { described_class.correct_carrier_icao_code('YYYY') }

      it { expect { code }.to raise_exception Exception }
    end
  end

  describe "#correct_flight_number" do
    context 'when iata' do
      context 'when correct number' do
        let(:flight_number) { described_class.correct_flight_number('XX000') }

        it { expect(flight_number).to eq({ flight_iata: 'XX0000', flight_icao: '' }) }
      end

      context 'when incorrect number' do
        let(:flight_number) { described_class.correct_flight_number('X_0000') }

        it { expect(flight_number).to be_nil }
      end
    end

    context 'when icao' do
      context 'when correct number' do
        let(:flight_number) { described_class.correct_flight_number('XXX0000') }

        it { expect(flight_number).to eq({ flight_icao: 'XXX0000', flight_iata: '' }) }
      end

      context 'when incorrect number' do
        let(:flight_number) { described_class.correct_flight_number('Y_Y0000') }

        it { expect(flight_number).to be_nil }
      end
    end

  end
end