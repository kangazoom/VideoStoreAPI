class Customer < ApplicationRecord
  has_many :rentals, dependent: :delete_all


end
