require 'rails_helper'

RSpec.describe Atm do
  describe 'initialize' do
    it 'exists and has attributes' do
      data = {
        "name": 'ATM',
        "address": '3902 Central Avenue Southeast, Albuquerque, NM 87108',
        "lat": 35.07904,
        "lon": -106.60068,
        "distance": 169.766658
      }
      atm = Atm.new(data)

      expect(atm).to be_an(Atm)
      expect(atm.name).to eq(data[:name])
      expect(atm.address).to eq(data[:address])
      expect(atm.lat).to eq(data[:lat])
      expect(atm.lon).to eq(data[:lon])
      expect(atm.distance).to eq(0.10548811068360774)
    end

    it 'can initalize another object' do
      data = {
        "name": 'ATM at Efx',
        "address": '4720 Central Avenue Southeast, Albuquerque, NM 87108',
        "lat": 35.078207,
        "lon": -106.591563,
        "distance": 812.147842
      }
      atm = Atm.new(data)

      expect(atm).to be_an(Atm)
      expect(atm.name).to eq(data[:name])
      expect(atm.address).to eq(data[:address])
      expect(atm.lat).to eq(data[:lat])
      expect(atm.lon).to eq(data[:lon])
      expect(atm.distance).to eq(0.504645272856518)
    end
  end
end
