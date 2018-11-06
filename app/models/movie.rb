class Movie < ApplicationRecord
  has_many :rentals

  validates :title, presence: true, uniqueness: { scope: :release_date }

  # TODO: uncomment below once we know more about rentals

  # def calculate_available_inventory()
  #   total_inventory = self.inventory
  #   # QUESTION: will we be doing counter_cache?
  #   rented_inventory = self.rentals.length
  #
  #   return total_inventory - rented_inventory
  # end
end
