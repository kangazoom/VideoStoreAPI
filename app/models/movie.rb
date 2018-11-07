class Movie < ApplicationRecord
  has_many :rentals, dependent: :delete_all

  validates :title, presence: true, uniqueness: { scope: :release_date }

  # TODO: uncomment below once we know more about rentals


  def calculate_available_inventory()
    total_inventory = self.inventory
    # QUESTION: will we be doing counter_cache?
    rented_inventory = self.rentals.length

    available_inventory = total_inventory - rented_inventory

    if available_inventory < 0 || available_inventory.nil?
      # TODO: improve error handling here?
      raise StandardError, "AVAILABLE INVENTORY CANNOT BE LESS THAN ZERO"
    end

    return available_inventory
  end

  def save_available_inventory(calculate_available_inventory())
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
