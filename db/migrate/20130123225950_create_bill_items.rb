class CreateBillItems < ActiveRecord::Migration
  def change
    create_table :bill_items do |t|
      t.decimal :price, precision: 8, scale: 2, default: 0
      t.references :bill
      t.references :client
      t.references :event

      t.timestamps
    end
    add_index :bill_items, :bill_id
    add_index :bill_items, :client_id
    add_index :bill_items, :event_id
  end
end
