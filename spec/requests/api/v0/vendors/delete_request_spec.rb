require 'rails_helper'

describe 'Vendors API' do
  describe 'Delete a Vendor' do
    describe 'happy path' do
      it 'deletes a vendor and returns 204 status' do
        market = create(:market)
        vendor = create(:vendor)
        market_vendor = create(:market_vendor, market: market, vendor: vendor)

        expect { delete "/api/v0/vendors/#{vendor.id}" }.to change(Vendor, :count).by(-1)

        expect(response).to be_successful
        expect(response.status).to eq(204)
        expect { Vendor.find(vendor.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect { MarketVendor.find(market_vendor.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'sad path' do
      it 'returns error if Vendor does not exist' do
        false_id = 123123123123

        expect { delete "/api/v0/vendors/#{false_id}" }.to change(Vendor, :count).by(0)

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:errors)

        errors = data[:errors]

        expect(errors).to be_an(Array)
        expect(errors.first[:detail]).to eq("Couldn't find Vendor with 'id'=#{false_id}")
      end
    end
  end
end
