class Atm
  attr_reader :id,
              :name,
              :address,
              :lat,
              :lon,
              :distance

  def initialize(data)
    @name = data[:poi][:name]
    @address = data[:address][:freeformAddress]
    @lat = data[:position][:lat]
    @lon = data[:position][:lon]
    @distance = data[:dist] / 1609.344
    @id = nil
  end
end
