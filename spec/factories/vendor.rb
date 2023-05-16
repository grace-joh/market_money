FactoryBot.define do
  factory :vendor do
    name { "#{Faker::FunnyName.two_word_name}'s #{Faker::Commerce.department}" }
    description { Faker::Hipster.paragraph(sentence_count: 1) }
    contact_name { Faker::Name.name }
    contact_phone { Faker::Config.locale = 'en-US' }
    credit_accepted { Faker::Boolean.boolean }
  end
end
