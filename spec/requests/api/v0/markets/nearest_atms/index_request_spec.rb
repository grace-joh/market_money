require 'rails_helper'

describe 'Markets API' do
   describe 'Get Nearest Atms for a Market' do
    describe 'happy path' do
      it 'returns atms in order by nearest to the market' do
        VCR.use_cassette('nearby_atms') do
          market = create(:market, lat: '35.077529', lon: '-106.600449')

          get "/api/v0/markets/#{market.id}/nearest_atms"

          expect(response).to be_successful
          expect(response.status).to eq(200)

          atm_data = JSON.parse(response.body, symbolize_names: true)

          expect(atm_data).to have_key(:data)
          expect(atm_data[:data]).to be_an(Array)

          atms = atm_data[:data]

          atms.each do |atm|
            expect(atm).to have_key(:id)
            expect(atm[:id]).to be_nil

            expect(atm).to have_key(:type)
            expect(atm[:type]).to eq('atm')

            expect(atm).to have_key(:attributes)
            expect(atm[:attributes]).to be_a(Hash)

            attributes = atm[:attributes]

            expect(attributes[:name]).to be_a(String)
            expect(attributes[:address]).to be_a(String)
            expect(attributes[:lat]).to be_a(Float)
            expect(attributes[:lon]).to be_a(Float)
            expect(attributes[:distance]).to be_a(Float)
          end
        end
      end
    end

    describe 'sad path' do
      it 'returns 404 error if market id is invalid' do
        false_id = 1234567890

        get "/api/v0/markets/#{false_id}/nearest_atms"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        error = JSON.parse(response.body, symbolize_names: true)

        expect(error).to have_key(:errors)
        expect(error[:errors]).to be_an Array
        expect(error[:errors].first).to be_a Hash
        expect(error[:errors].first).to have_key(:detail)
        expect(error[:errors].first[:detail]).to be_a String
        expect(error[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=#{false_id}")
      end
    end
  end
end
