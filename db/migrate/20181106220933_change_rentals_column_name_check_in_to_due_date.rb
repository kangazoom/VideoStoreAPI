class ChangeRentalsColumnNameCheckInToDueDate < ActiveRecord::Migration[5.2]
  def change
    rename_column :rentals, :check_in, :due_date
  end
end
