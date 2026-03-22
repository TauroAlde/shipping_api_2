class AddIsCompletedToQuotationResults < ActiveRecord::Migration[8.1]
  def change
    add_column :quotation_results, :is_completed, :boolean
  end
end
