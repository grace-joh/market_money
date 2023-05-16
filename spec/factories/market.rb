FactoryBot.define do
  factory :market do
    name { "#{Faker::Address.community} Farmer's Market" }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    county { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end
