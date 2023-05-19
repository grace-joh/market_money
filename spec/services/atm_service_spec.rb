require 'rails_helper'

RSpec.describe AtmService do
  describe 'class methods' do
    describe 'nearby_atms' do
      it 'returns nearby atms' do
        search = AtmService.new.nearby_atms(35.077529, -106.600449)
        
        expect(search).to be_a(Hash)
        expect(search[:results]).to be_an Array
        atm_data = search[:results].first

        expect(atm_data).to have_key(:poi)
        expect(atm_data[:poi]).to have_key(:name)
        expect(atm_data[:poi][:name]).to eq('ATM')

        expect(atm_data).to have_key(:address)
        expect(atm_data[:address]).to have_key(:freeformAddress)
        expect(atm_data[:address][:freeformAddress]).to eq('3902 Central Avenue Southeast, Albuquerque, NM 87108')

        expect(atm_data).to have_key(:position)
        expect(atm_data[:position]).to have_key(:lat)
        expect(atm_data[:position][:lat]).to eq(35.079044)
        expect(atm_data[:position]).to have_key(:lon)
        expect(atm_data[:position][:lon]).to eq(-106.60068)

        expect(atm_data).to have_key(:dist)
        expect(atm_data[:dist]).to eq(169.766658)
      end
    end
  end
end
