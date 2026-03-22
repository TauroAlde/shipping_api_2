class CreateShipmentStats < ActiveRecord::Migration[8.1]
  def change
    create_table :shipment_stats do |t|
      t.string :carrier
      t.integer :deliveries
      t.integer :failures
      t.float :avg_days

      t.timestamps
    end
  end
end
