require 'rails_helper'

RSpec.describe Flight do
  let(:flight) { create(:flight) }

  describe 'associations' do
    it 'have many routes' do
      expect(flight).to have_many(:routes)
    end
  end
end
