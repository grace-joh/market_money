require 'rails_helper'

describe 'Markets API' do
  describe 'Get all Vendors for a Market' do
    describe 'happy path' do
      it 'returns all vendors for a market' do
        market1 = create(:market)
        vendors = create_list(:vendor, 3)
        vendor4 = create(:vendor)

        vendors.each do |vendor|
          create(:market_vendor, market: market1, vendor: vendor)
        end

        get "/api/v0/markets/#{market1.id}/vendors"

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:data)

        vendors_data = data[:data]

        vendors_data.each do |vendor|
          expect(vendor).to have_key(:id)
          expect(vendor[:id]).to be_a(String)
          expect(vendor[:id]).to_not eq(vendor4.id.to_s)

          expect(vendor).to have_key(:type)
          expect(vendor[:type]).to eq('vendor')

          expect(vendor).to have_key(:attributes)
          expect(vendor[:attributes]).to be_a(Hash)

          attributes = vendor[:attributes]

          expect(attributes).to have_key(:name)
          expect(attributes[:name]).to be_a(String)

          expect(attributes).to have_key(:description)
          expect(attributes[:description]).to be_a(String)

          expect(attributes).to have_key(:contact_name)
          expect(attributes[:contact_name]).to be_a(String)

          expect(attributes).to have_key(:contact_phone)
          expect(attributes[:contact_phone]).to be_a(String)

          expect(attributes).to have_key(:credit_accepted)
          expect(attributes[:credit_accepted]).to be(true).or be(false)
        end
      end
    end

    describe 'sad path' do
      it 'returns error if market does not exist' do
        false_id = 123123123123
        get "/api/v0/markets/#{false_id}/vendors"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:errors)

        errors = data[:errors]

        expect(errors).to be_an(Array)
        expect(errors.first[:detail]).to eq("Couldn't find Market with 'id'=#{false_id}")
      end
    end
  end
end
