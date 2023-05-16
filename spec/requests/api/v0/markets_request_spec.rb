require 'rails_helper'

describe 'Markets API' do
  it 'gets all markets' do
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

      expect(attributes).to have_key(:id)
      expect(attributes[:id]).to be_an(Integer)

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

  it 'returns the count of vendors for a market' do
    market = create(:market)
    vendors = create_list(:vendor, 3)

    create(:market_vendor, market: market, vendor: vendors[0])
    create(:market_vendor, market: market, vendor: vendors[1])

    get '/api/v0/markets'

    data = JSON.parse(response.body, symbolize_names: true)
    market_data = data[:data].first

    expect(market_data[:attributes][:vendor_count]).to eq(2)
  end
end
