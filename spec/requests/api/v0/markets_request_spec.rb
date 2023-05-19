require 'rails_helper'

describe 'Markets API' do
  describe 'gets all Markets' do
    it 'returns all markets and vendor count' do
      create_list(:market, 3)

      get '/api/v0/markets'

      expect(response).to be_successful

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to have_key(:data)

      markets = data[:data]
      expect(markets).to be_an(Array)
      expect(markets.count).to eq(3)

      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_a(String)

        expect(market).to have_key(:type)
        expect(market[:type]).to eq("market")

        expect(market).to have_key(:attributes)
        expect(market[:attributes]).to be_a(Hash)

        attributes = market[:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)

        expect(attributes).to have_key(:street)
        expect(attributes[:street]).to be_a(String)

        expect(attributes).to have_key(:city)
        expect(attributes[:city]).to be_a(String)

        expect(attributes).to have_key(:county)
        expect(attributes[:county]).to be_a(String)

        expect(attributes).to have_key(:state)
        expect(attributes[:state]).to be_a(String)

        expect(attributes).to have_key(:zip)
        expect(attributes[:zip]).to be_a(String)

        expect(attributes).to have_key(:lat)
        expect(attributes[:lat]).to be_a(String)

        expect(attributes).to have_key(:lon)
        expect(attributes[:lon]).to be_a(String)

        expect(attributes).to have_key(:vendor_count)
        expect(attributes[:vendor_count]).to be_an(Integer)
      end
    end
  end

  describe 'gets one Market' do
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

  describe 'gets all Vendors for a Market' do
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

  describe 'search Markets' do
    describe 'happy path' do
      it 'returns markets searched by state' do
        market_search_data
        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v0/markets/search?state=co', headers: headers

        expect(response).to be_successful
        expect(response.status).to eq(200)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:data)

        markets = data[:data]
        expect(markets).to be_an(Array)
        expect(markets.count).to eq(3)

        markets.each do |market|
          expect(market[:id]).to be_a(String)
          expect(market[:type]).to eq("market")
          expect(market[:attributes]).to be_a(Hash)

          attributes = market[:attributes]
          expect(attributes[:street]).to be_a(String)
          expect(attributes[:county]).to be_a(String)
          expect(attributes[:zip]).to be_a(String)
          expect(attributes[:lat]).to be_a(String)
          expect(attributes[:lon]).to be_a(String)
          expect(attributes[:vendor_count]).to be_an(Integer)
        end

        market1 = markets[0]
        market2 = markets[1]
        market3 = markets[2]

        expect(market1[:attributes][:name]).to eq(@market4.name)
        expect(market1[:attributes][:city]).to eq(@market4.city)
        expect(market1[:attributes][:state]).to eq(@market4.state)
        expect(market2[:attributes][:name]).to eq(@market5.name)
        expect(market2[:attributes][:city]).to eq(@market5.city)
        expect(market2[:attributes][:state]).to eq(@market5.state)
        expect(market3[:attributes][:name]).to eq(@market6.name)
        expect(market3[:attributes][:city]).to eq(@market6.city)
        expect(market3[:attributes][:state]).to eq(@market6.state)
      end

      it 'finds all market by state and city' do
        market_search_data
        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v0/markets/search?city=ville&state=co', headers: headers

        expect(response).to be_successful
        expect(response.status).to eq(200)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:data)

        markets = data[:data]
        expect(markets).to be_an(Array)
        expect(markets.count).to eq(2)

        markets.each do |market|
          expect(market[:id]).to be_a(String)
          expect(market[:type]).to eq("market")
          expect(market[:attributes]).to be_a(Hash)

          attributes = market[:attributes]
          expect(attributes[:street]).to be_a(String)
          expect(attributes[:county]).to be_a(String)
          expect(attributes[:zip]).to be_a(String)
          expect(attributes[:lat]).to be_a(String)
          expect(attributes[:lon]).to be_a(String)
          expect(attributes[:vendor_count]).to be_an(Integer)
        end

        market1 = markets[0]
        market2 = markets[1]

        expect(market1[:attributes][:name]).to eq(@market4.name)
        expect(market1[:attributes][:city]).to eq(@market4.city)
        expect(market1[:attributes][:state]).to eq(@market4.state)
        expect(market2[:attributes][:name]).to eq(@market5.name)
        expect(market2[:attributes][:city]).to eq(@market5.city)
        expect(market2[:attributes][:state]).to eq(@market5.state)
      end

      it 'finds all market by state, city, and name (result of 1 still returns in an array)' do
        market_search_data
        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v0/markets/search?name=farm&city=ville&state=co', headers: headers

        expect(response).to be_successful
        expect(response.status).to eq(200)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:data)

        markets = data[:data]
        expect(markets).to be_an(Array)
        expect(markets.count).to eq(1)

        markets.each do |market|
          expect(market[:id]).to be_a(String)
          expect(market[:type]).to eq("market")
          expect(market[:attributes]).to be_a(Hash)

          attributes = market[:attributes]
          expect(attributes[:street]).to be_a(String)
          expect(attributes[:county]).to be_a(String)
          expect(attributes[:zip]).to be_a(String)
          expect(attributes[:lat]).to be_a(String)
          expect(attributes[:lon]).to be_a(String)
          expect(attributes[:vendor_count]).to be_an(Integer)
        end

        expect(markets[0][:attributes][:name]).to eq(@market4.name)
        expect(markets[0][:attributes][:city]).to eq(@market4.city)
        expect(markets[0][:attributes][:state]).to eq(@market4.state)
      end

      it 'finds all market by state and name' do
        market_search_data
        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v0/markets/search?name=mark&state=tex', headers: headers

        expect(response).to be_successful
        expect(response.status).to eq(200)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:data)

        markets = data[:data]
        expect(markets).to be_an(Array)
        expect(markets.count).to eq(3)

        markets.each do |market|
          expect(market[:id]).to be_a(String)
          expect(market[:type]).to eq("market")
          expect(market[:attributes]).to be_a(Hash)

          attributes = market[:attributes]
          expect(attributes[:street]).to be_a(String)
          expect(attributes[:county]).to be_a(String)
          expect(attributes[:zip]).to be_a(String)
          expect(attributes[:lat]).to be_a(String)
          expect(attributes[:lon]).to be_a(String)
          expect(attributes[:vendor_count]).to be_an(Integer)
        end

        market1 = markets[0]
        market2 = markets[1]
        market3 = markets[2]

        expect(market1[:attributes][:name]).to eq(@market1.name)
        expect(market1[:attributes][:city]).to eq(@market1.city)
        expect(market1[:attributes][:state]).to eq(@market1.state)
        expect(market2[:attributes][:name]).to eq(@market2.name)
        expect(market2[:attributes][:city]).to eq(@market2.city)
        expect(market2[:attributes][:state]).to eq(@market2.state)
        expect(market3[:attributes][:name]).to eq(@market3.name)
        expect(market3[:attributes][:city]).to eq(@market3.city)
        expect(market3[:attributes][:state]).to eq(@market3.state)
      end

      it 'finds all market by name' do
        market_search_data
        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v0/markets/search?name=farm', headers: headers

        expect(response).to be_successful
        expect(response.status).to eq(200)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:data)

        markets = data[:data]
        expect(markets).to be_an(Array)
        expect(markets.count).to eq(4)

        markets.each do |market|
          expect(market[:id]).to be_a(String)
          expect(market[:type]).to eq("market")
          expect(market[:attributes]).to be_a(Hash)

          attributes = market[:attributes]
          expect(attributes[:street]).to be_a(String)
          expect(attributes[:county]).to be_a(String)
          expect(attributes[:zip]).to be_a(String)
          expect(attributes[:lat]).to be_a(String)
          expect(attributes[:lon]).to be_a(String)
          expect(attributes[:vendor_count]).to be_an(Integer)
        end

        market1 = markets[0]
        market2 = markets[1]
        market3 = markets[2]
        market4 = markets[3]

        expect(market1[:attributes][:name]).to eq(@market1.name)
        expect(market1[:attributes][:city]).to eq(@market1.city)
        expect(market1[:attributes][:state]).to eq(@market1.state)
        expect(market2[:attributes][:name]).to eq(@market2.name)
        expect(market2[:attributes][:city]).to eq(@market2.city)
        expect(market2[:attributes][:state]).to eq(@market2.state)
        expect(market3[:attributes][:name]).to eq(@market3.name)
        expect(market3[:attributes][:city]).to eq(@market3.city)
        expect(market3[:attributes][:state]).to eq(@market3.state)
        expect(market4[:attributes][:name]).to eq(@market4.name)
        expect(market4[:attributes][:city]).to eq(@market4.city)
        expect(market4[:attributes][:state]).to eq(@market4.state)
      end

      it 'returns empty array if params are valid but no markets are returned' do
        market_search_data
        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v0/markets/search?state=tx', headers: headers

        expect(response).to be_successful
        expect(response.status).to eq(200)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:data)

        markets = data[:data]
        expect(markets).to be_an(Array)
        expect(markets.count).to eq(0)
      end
    end

    describe 'sad path' do
      it 'returns 422 error if only city parameter is passed' do
        market_search_data
        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v0/markets/search?city=tx', headers: headers

        expect(response).to_not be_successful
        expect(response.status).to eq(422)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:errors)

        errors = data[:errors]
        expect(errors).to be_an(Array)
        expect(errors.first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
      end

      it 'returns 422 error if city and name parameters are passed' do
        market_search_data
        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v0/markets/search?city=error&name=422', headers: headers

        expect(response).to_not be_successful
        expect(response.status).to eq(422)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:errors)

        errors = data[:errors]
        expect(errors).to be_an(Array)
        expect(errors.first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
      end

      it 'returns 422 error if no parameters are passed' do
        market_search_data
        headers = { 'CONTENT_TYPE' => 'application/json' }

        get '/api/v0/markets/search?', headers: headers

        expect(response).to_not be_successful
        expect(response.status).to eq(422)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:errors)

        errors = data[:errors]
        expect(errors).to be_an(Array)
        expect(errors.first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
      end
    end
  end

  describe 'get atms nearby market' do
    describe 'happy path' do
      it 'returns atms in order by nearest to the market' do
        VCR.use_cassette("nearby_atms") do
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
