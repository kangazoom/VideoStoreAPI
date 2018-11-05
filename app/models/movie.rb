class Movie < ApplicationRecord
  has_many :rentals

  validates :title, presence: true, uniqueness: { scope: :release_date }
end
