require 'rails_helper'

describe 'Markets API' do
  describe 'Search Markets' do
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
        expect(errors.first[:detail]).to eq('Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.')
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
        expect(errors.first[:detail]).to eq('Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.')
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
        expect(errors.first[:detail]).to eq('Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.')
      end
    end
  end
end
