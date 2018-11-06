class Movie < ApplicationRecord
  has_many :rentals

  validates :title, presence: true, uniqueness: { scope: :release_date }

  # TODO: uncomment below once we know more about rentals

  def calculate_available_inventory()
    total_inventory = self.inventory
    # QUESTION: will we be doing counter_cache?
    rented_inventory = self.rentals.length

    available_inventory = total_inventory - rented_inventory

    if available_inventory < 0
      # TODO: improve error handling here?
      raise StandardError, "AVAILABLE INVENTORY CANNOT BE LESS THAN ZERO"
    end

    self.available_inventory = available_inventory
    # QUESTION: error handling for successful or failed save?
    self.save

    # necessary? or do this outside of function?

    return self.available_inventory
  end
end
