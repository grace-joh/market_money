require 'rails_helper'

describe 'MarketVendors API' do
  describe 'Delete a MarketVendor' do
    describe 'happy path' do
      before(:each) do
        @market = create(:market)
        @vendor = create(:vendor)
        create(:market_vendor, market: @market, vendor: @vendor)

        expect(MarketVendor.count).to eq(1)

        market_vendor_params = { market_id: @market.id, vendor_id: @vendor.id }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)
      end

      it 'deletes a marketvendor and returns 204 status' do
        expect(response).to be_successful
        expect(response.status).to eq(204)
        expect(response.body).to eq('')
        expect(MarketVendor.count).to eq(0)
      end

      it 'no longer lists the vendor in the market/vendors request' do
        get "/api/v0/markets/#{@market.id}/vendors"
        expect(response).to be_successful
        expect(response.status).to eq(200)

        data = JSON.parse(response.body, symbolize_names: true)
        expect(data).to have_key(:data)

        vendors_data = data[:data]
        expect(vendors_data).to be_an(Array)
        expect(vendors_data.count).to eq(0)
      end
    end

    describe 'sad path' do
      it 'returns error if MarketVendor vendor does not exist' do
        market = create(:market)
        false_id = 123123123123

        market_vendor_params = {
          "market_id": market.id,
          "vendor_id": false_id
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }

        delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:errors)

        errors = data[:errors]

        expect(errors).to be_an(Array)
        expect(errors.first[:detail]).to eq("No MarketVendor with market_id=#{market.id} AND vendor_id=#{false_id} exists")
      end
    end
  end
end
