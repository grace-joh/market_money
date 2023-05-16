class MarketSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :street, :city, :county, :state, :zip, :lat, :lon

  attribute :vendor_count do |market|
    market.vendors.count
  end
end
