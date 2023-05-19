require 'rails_helper'

RSpec.describe AtmService do
  describe 'class methods' do
    describe 'nearby_atms' do
      it 'returns nearby atms' do
        VCR.use_cassette("nearby_atms") do
          search = AtmService.new.nearby_atms(35.077529, -106.600449)

          expect(search).to be_a(Hash)
          expect(search[:results]).to be_an Array
          expect(search[:results].count).to eq(10)

          first_atm_data = search[:results].first

          expect(first_atm_data).to have_key(:poi)
          expect(first_atm_data[:poi]).to have_key(:name)
          expect(first_atm_data[:poi][:name]).to eq('ATM')

          expect(first_atm_data).to have_key(:address)
          expect(first_atm_data[:address]).to have_key(:freeformAddress)
          expect(first_atm_data[:address][:freeformAddress]).to eq('3902 Central Avenue Southeast, Albuquerque, NM 87108')

          expect(first_atm_data).to have_key(:position)
          expect(first_atm_data[:position]).to have_key(:lat)
          expect(first_atm_data[:position][:lat]).to eq(35.079044)
          expect(first_atm_data[:position]).to have_key(:lon)
          expect(first_atm_data[:position][:lon]).to eq(-106.60068)

          expect(first_atm_data).to have_key(:dist)
          expect(first_atm_data[:dist]).to eq(169.766658)

          last_atm_data = search[:results].last

          expect(last_atm_data).to have_key(:poi)
          expect(last_atm_data[:poi]).to have_key(:name)
          expect(last_atm_data[:poi][:name]).to eq('ATM at Efx')

          expect(last_atm_data).to have_key(:address)
          expect(last_atm_data[:address]).to have_key(:freeformAddress)
          expect(last_atm_data[:address][:freeformAddress]).to eq('4720 Central Avenue Southeast, Albuquerque, NM 87108')

          expect(last_atm_data).to have_key(:position)
          expect(last_atm_data[:position]).to have_key(:lat)
          expect(last_atm_data[:position][:lat]).to eq(35.078207)
          expect(last_atm_data[:position]).to have_key(:lon)
          expect(last_atm_data[:position][:lon]).to eq(-106.591563)

          expect(last_atm_data).to have_key(:dist)
          expect(last_atm_data[:dist]).to eq(812.147842)
        end
      end
    end
  end
end
