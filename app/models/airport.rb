class Airport < ApplicationRecord
  has_many :routes, class_name: 'Route'
end
