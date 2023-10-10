FactoryBot.define do
  factory :airport do
    latitude { Faker::Number::between(from: -180, to: 180) }
    longitude { Faker::Number::between(from: -180, to: 180) }
    city { Faker::Address::city }
    country { Faker::Address::country }
    iata { Faker::Lorem::characters(number: 3) }
  end
end