require 'rails_helper'

describe 'Markets API' do
  describe 'Get one Market' do
    describe 'happy path' do
      it 'returns one market' do
        market1 = create(:market)
        vendor1 = create(:vendor)

        create(:market_vendor, market: market1, vendor: vendor1)

        get "/api/v0/markets/#{market1.id}"

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:data)

        market_data = data[:data]

        expect(market_data).to have_key(:id)
        expect(market_data[:id]).to be_a(String)

        expect(market_data).to have_key(:type)
        expect(market_data[:type]).to eq('market')

        expect(market_data).to have_key(:attributes)
        expect(market_data[:attributes]).to be_a(Hash)

        attributes = market_data[:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to eq(market1.name)

        expect(attributes).to have_key(:street)
        expect(attributes[:street]).to eq(market1.street)

        expect(attributes).to have_key(:city)
        expect(attributes[:city]).to eq(market1.city)

        expect(attributes).to have_key(:county)
        expect(attributes[:county]).to eq(market1.county)

        expect(attributes).to have_key(:state)
        expect(attributes[:state]).to eq(market1.state)

        expect(attributes).to have_key(:zip)
        expect(attributes[:zip]).to eq(market1.zip)

        expect(attributes).to have_key(:lat)
        expect(attributes[:lat]).to eq(market1.lat)

        expect(attributes).to have_key(:lon)
        expect(attributes[:lon]).to eq(market1.lon)

        expect(attributes).to have_key(:vendor_count)
        expect(attributes[:vendor_count]).to eq(market1.vendor_count)
      end
    end

    describe 'sad path' do
      it 'returns error if market does not exist' do
        false_id = 123123123123
        get "/api/v0/markets/#{false_id}"

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
