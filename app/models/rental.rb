class Rental < ApplicationRecord
  belongs_to :movie
  belongs_to :customer

  validates :customer_id, presence: true
  validates :movie_id, presence: true

  def checked_out?()
    return self.checkedout == true
  end


  # def calculate_checked_out_rentals()
  #   rentals = self.rentals
  #
  #   rented_inventory = rentals.sum { |rental| rental.checkout==true }
  #
  #   return rented_inventory
  # end

end
