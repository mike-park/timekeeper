class CreateEventCategoryPrices < ActiveRecord::Migration
  def change
    create_table :event_category_prices do |t|
      t.string :title
      t.decimal :price, precision: 8, scale: 2
      t.references :event_category

      t.timestamps
    end
    add_index :event_category_prices, :event_category_id
  end
end
