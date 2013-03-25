class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.date :billed_on
      t.references :therapist
      t.string :number

      t.timestamps
    end
    add_index :bills, :therapist_id
  end
end
