class AddRequestedCarriersToQuotations < ActiveRecord::Migration[8.1]
  def change
    add_column :quotations, :requested_carriers, :jsonb, default: []
  end
end
