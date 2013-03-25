class CreatePraxisBills < ActiveRecord::Migration
  def change
    create_table :praxis_bills do |t|
      t.date :billed_on
      t.string :number
      t.text :note
      t.references :user

      t.timestamps
    end
    add_index :praxis_bills, :user_id
    add_index :praxis_bills, :billed_on

    add_column :bills, :praxis_bill_id, :integer
    add_index :bills, :praxis_bill_id
  end
end
