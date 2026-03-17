class CreateShipmentEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :shipment_events do |t|
      t.references :shipment, null: false, foreign_key: true
      t.string :status
      t.jsonb :metadata

      t.timestamps
    end
  end
end
