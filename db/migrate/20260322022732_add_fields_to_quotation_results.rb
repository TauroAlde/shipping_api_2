class AddFieldsToQuotationResults < ActiveRecord::Migration[8.1]
  def change
    add_reference :quotation_results, :quotation, null: false, foreign_key: true

    add_column :quotation_results, :carrier, :string, null: false
    add_column :quotation_results, :service, :string

    add_column :quotation_results, :price, :decimal, precision: 10, scale: 2
    add_column :quotation_results, :days, :integer

    # 💣 para ranking
    add_column :quotation_results, :score, :float
    add_column :quotation_results, :reliability, :float

    # 📦 extra
    add_column :quotation_results, :currency, :string
    add_column :quotation_results, :raw_response, :jsonb

    add_index :quotation_results, :carrier
  end
end
