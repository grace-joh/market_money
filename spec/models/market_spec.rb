require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'scopes' do
    before(:each) do
      market_search_data
    end

    describe 'search_by_name' do
      it 'returns markets searched by name farm' do
        expect(Market.search_by_name('farm')).to eq([@market1, @market2, @market3, @market4])
      end
    end

    describe 'search_by_city' do
      it 'returns markets searched by city ville' do
        expect(Market.search_by_city('ville')).to eq([@market2, @market4, @market5])
      end
    end

    describe 'search_by_state' do
      it 'returns markets searched by state co' do
        expect(Market.search_by_state('co')).to eq([@market4, @market5, @market6])
      end
    end
  end

  describe 'class methods' do
    before(:each) do
      market_search_data
    end

    describe 'search_all' do
      it 'returns markets searched by name farm' do
        params = { 'name': 'farm' }
        expect(Market.search_all(params)).to eq([@market1, @market2, @market3, @market4])
      end

      it 'returns markets searched by city ville' do
        params = { 'city': 'ville' }
        expect(Market.search_all(params)).to eq([@market2, @market4, @market5])
      end

      it 'returns markets searched by state co' do
        params = { 'state': 'co' }
        expect(Market.search_all(params)).to eq([@market4, @market5, @market6])
      end

      it 'returns markets searched by two fields' do
        params = { 'city': 'ville', 'state': 'co' }
        expect(Market.search_all(params)).to eq([@market4, @market5])
      end

      it 'returns markets searched by three fields' do
        params = { 'name': 'farm', 'city': 'ville', 'state': 'co' }
        expect(Market.search_all(params)).to eq([@market4])
      end
    end
  end

  describe 'instance methods' do
    describe 'vendor_count' do
      it 'returns the count of vendors for a market' do
        market1 = create(:market)
        vendors = create_list(:vendor, 3)

        create(:market_vendor, market: market1, vendor: vendors[0])
        create(:market_vendor, market: market1, vendor: vendors[1])

        expect(market1.vendor_count).to eq(2)
      end
    end
  end
end
