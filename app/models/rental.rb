class Rental < ApplicationRecord
  belongs_to :movies
  belongs_to :customers
end
