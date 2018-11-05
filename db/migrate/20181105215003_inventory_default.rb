class InventoryDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :movies, :inventory, :integer, default: 0
  end
end
