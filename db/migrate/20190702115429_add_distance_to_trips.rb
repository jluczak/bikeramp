class AddDistanceToTrips < ActiveRecord::Migration[5.2]
  def change
    add_column :trips, :distance, :float, null: false
  end
end
