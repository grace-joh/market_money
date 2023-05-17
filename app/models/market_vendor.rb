class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validate :unique_association, on: :create

  private

  def unique_association
    market_vendor = MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id)
    return unless market_vendor && self != market_vendor

    errors.add(:base, "Market vendor association between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists")
  end
end
