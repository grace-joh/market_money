require 'rails_helper'

RSpec.describe Atm do
  describe 'initialize' do
    it 'exists and has attributes' do
      data = {
        poi: { name: 'ATM' },
        address: { freeformAddress: '3902 Central Avenue Southeast, Albuquerque, NM 87108' },
        position: { "lat": 35.07904, "lon": -106.60068 },
        dist: 169.766658
      }
      atm = Atm.new(data)

      expect(atm).to be_an(Atm)
      expect(atm.id).to eq(nil)
      expect(atm.name).to eq(data[:poi][:name])
      expect(atm.address).to eq(data[:address][:freeformAddress])
      expect(atm.lat).to eq(data[:position][:lat])
      expect(atm.lon).to eq(data[:position][:lon])
      expect(atm.distance).to eq(0.10548811068360774)
    end

    it 'can initalize another object' do
      data = {
        poi: { name: 'ATM at Efx' },
        address: { freeformAddress: '4720 Central Avenue Southeast, Albuquerque, NM 87108' },
        position: { "lat": 35.078207, "lon": -106.591563 },
        dist: 812.147842
      }
      atm = Atm.new(data)

      expect(atm).to be_an(Atm)
      expect(atm.name).to eq(data[:poi][:name])
      expect(atm.address).to eq(data[:address][:freeformAddress])
      expect(atm.lat).to eq(data[:position][:lat])
      expect(atm.lon).to eq(data[:position][:lon])
      expect(atm.distance).to eq(0.504645272856518)
      expect(atm.id).to eq(nil)
    end
  end
end
