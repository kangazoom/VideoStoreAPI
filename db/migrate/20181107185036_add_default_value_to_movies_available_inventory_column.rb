class AddDefaultValueToMoviesAvailableInventoryColumn < ActiveRecord::Migration[5.2]
  def change
    change_column_default :movies, :available_inventory, 0
  end
end
