class CreateShipmentResults < ActiveRecord::Migration[8.1]
  def change
    create_table :shipment_results do |t|
      t.timestamps
    end
  end
end
