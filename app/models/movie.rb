class Movie < ApplicationRecord
  has_many :rentals, dependent: :delete_all

  validates :title, presence: true, uniqueness: { scope: :release_date }
  validates :release_date, presence: true
  validates :inventory, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :available_inventory, numericality: { greater_than_or_equal_to: 0, only_integer: true }


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
      # We decided to return 0 in this case since if the value somehow dips below 0, then user shouldn't be able to rent this particular movie
      return 0
    else

      return available_inventory
    end
  end

  def save_available_inventory(calculate_available_inventory)
    available_inventory = calculate_available_inventory

    self.available_inventory = available_inventory
    result = self.save

    if !result
      # NOTE: this is for our benefit; not the user's - it is unlikely they will reach this point given safeguards in calculate_available_inventory.
      raise StandardError, "Unable to save available inventory: must be a non-negative integer"
    end

    return result
  end

end
