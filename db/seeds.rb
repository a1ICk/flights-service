Route.destroy_all

Airport.destroy_all

Flight.destroy_all

flight1 = Flight.create(
  flight_number: 'AABBBB',
  distance: 0
)

flight2 = Flight.create(
  flight_number: 'XXZZZZ',
  distance: 0
)



airport1 = Airport.create!(
  iata: 'JFK',
  city: 'New York',
  country: 'USA',
  latitude: 40.7128,
  longitude: -74.0060
)

airport2 = Airport.create!(
  iata: 'LAX',
  city: 'Los Angeles',
  country: 'USA',
  latitude: 34.0522,
  longitude: -118.2437
)

route1 = Route.create!(
  distance: 54353.7,
  departure_airport_id: airport2.id,
  arrival_airport_id: airport1.id,
  flight_id: flight2.id
)
route2 = Route.create!(
  distance: 5432.12,
  departure_airport_id: airport1.id,
  arrival_airport_id: airport2.id,
  flight_id: flight2.id
)

p 'Seeded'