require 'rails_helper'
require_relative '../../app/services/service'
require_relative '../../app/services/parser'
require_relative '../../app/services/csv_writer'
require_relative '../../app/services/correct_flight'

RSpec.describe Service::CSVWriter do
  describe '::get_all_flights' do
    let(:flights_list) { described_class.send(:get_all_flights, 'flight_numbers.csv') }

    it { expect(flights_list).to be_instance_of Array }
    it { expect(flights_list).to all(be_instance_of String) }
  end

  describe "::write_line" do
    let(:csv) { Tempfile.new(%w[temp .csv]) }

    context 'when given not nil flight' do
      let(:departure_airport) { create(:airport) }
      let(:arrival_airport) { create(:airport) }
      let(:route) { create(:route, arrival_airport: arrival_airport, departure_airport: departure_airport) }
      let(:flight) { create(:flight, routes: [route]) }
      let(:line) { described_class.write_line(csv, flight, flight.flight_number) }

      it { expect(line).to be_truthy }
    end

    context "when flight is nil" do
      let(:line) { described_class.write_line(csv, nil, 'XXZZZZ') }

      it { expect(line).to be_falsey }
    end
  end

  describe '::write' do
    context "when correct path" do
      let(:writer) { described_class.write('flight_numbers.csv') }

      it { expect(writer).to be_truthy }
    end

    context "when incorrect path" do
      let(:writer) { described_class.write('flight_number.csv') }

      it { expect(writer).to be_falsey }
    end
  end
end
