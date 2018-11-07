class AddCheckedOutColumnToRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :checkedout, :boolean, default: true
  end
end
