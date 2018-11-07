class Movie < ApplicationRecord
  has_many :rentals, dependent: :delete_all

  validates :title, presence: true, uniqueness: { scope: :release_date }
  validates :inventory, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :available_inventory, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  # TODO: uncomment below once we know more about rentals

  def calculate_checked_out_rentals()
    rentals = self.rentals

    rented_inventory = rentals.count { |rental| rental.checked_out? }

    return rented_inventory
  end

  def calculate_available_inventory()
    total_inventory = self.inventory
    # QUESTION: will we be doing counter_cache?
    rented_inventory = calculate_checked_out_rentals()

    available_inventory = total_inventory - rented_inventory

    if !(available_inventory >= 0)
      # TODO: improve error handling here?
      raise StandardError, "AVAILABLE INVENTORY CANNOT BE LESS THAN ZERO"
    end

    return available_inventory
  end

  def save_available_inventory(calculate_available_inventory)
    available_inventory = calculate_available_inventory()

    self.available_inventory = available_inventory
    # QUESTION: error handling for successful or failed save?
    result = self.save

    if !result
      raise StandardError, "COULD NOT SAVE AVAILABLE INVENTORY"
    end

    return result
  end

end
