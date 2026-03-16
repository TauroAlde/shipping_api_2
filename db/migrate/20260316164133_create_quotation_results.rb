class CreateQuotationResults < ActiveRecord::Migration[8.1]
  def change
    create_table :quotation_results do |t|
      t.timestamps
    end
  end
end
