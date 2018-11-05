class Movie < ApplicationRecord
  has_many :rentals

  validate :name, presence: true
end
