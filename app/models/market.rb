class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
  scope :search_by_city, ->(city) { where('city ILIKE ?', "%#{city}%") }
  scope :search_by_state, ->(state) { where('state ILIKE ?', "%#{state}%") }

  def vendor_count
    vendors.count
  end

  def self.search_all(params)
    results = all
    params.each do |key, value|
      results = results.public_send("search_by_#{key}", value) if value.present?
    end
    results
  end
end
