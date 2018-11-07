class Rental < ApplicationRecord
  belongs_to :movies
  belongs_to :customers

  validates :customer_id, presence: true
  validates :movie_id, presence: true
end
