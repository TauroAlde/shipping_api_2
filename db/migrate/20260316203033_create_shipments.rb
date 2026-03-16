class CreateShipments < ActiveRecord::Migration[8.1]
  def change
    create_table :shipments do |t|
      t.string :skydropx_id
      t.string :rate_id
      t.string :carrier
      t.string :service_id
      t.string :tracking_number
      t.string :tracking_status
      t.string :tracking_url
      t.string :label_url
      t.string :workflow_status
      t.string :payment_status
      t.decimal :total
      t.jsonb :metadata

      t.timestamps
    end
    add_index :shipments, :skydropx_id
  end
end
