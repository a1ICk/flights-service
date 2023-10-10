FactoryBot.define do
  factory :route do
    distance { Faker::Number::between(from: 0, to: 10000) }
    departure_airport { association :airport }
    arrival_airport { association :airport }
    flight { association :flight }
  end
end