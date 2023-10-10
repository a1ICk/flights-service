FactoryBot.define do
  factory :flight do
    distance { Faker::Number::between(from: 0, to: 10000) }
    flight_number { Faker::Lorem.characters(number: 2).upcase + Faker::Number::between(from: 0, to: 9999).to_s }
  end
end