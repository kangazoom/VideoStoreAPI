class AddNoFalseToInventoryColumn < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:movies, :inventory, false)
  end
end
