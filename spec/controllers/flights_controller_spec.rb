require 'rails_helper'

RSpec.describe FlightsController do
  describe 'GET show' do
    let(:flight) { create(:flight) }
    let(:json_response) { JSON.parse(response.body) }

    context 'when correct request' do
      before { get :show, params: { flight_number: flight.flight_number } }

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns JSON response with keys' do
        expect(json_response.keys).to match_array(%w[data included])
      end
    end
    context 'when incorrect request' do
      before { get :show, params: { flight_number: 'LO4' } }

      it 'returns a 200' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns JSON response with keys' do
        expect(json_response.keys).to match_array(%w[routes error_message status distance])
      end
    end
  end
end