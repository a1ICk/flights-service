class Flight < ApplicationRecord
  has_many :routes, class_name: 'Route'
end
