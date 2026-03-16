class CreateQuotations < ActiveRecord::Migration[8.1]
  def change
    create_table :quotations do |t|
      t.timestamps
    end
  end
end
