class CreateEventCategories < ActiveRecord::Migration
  def change
    create_table :event_categories do |t|
      t.string :title
      t.string :abbrv
      t.integer :sort_order
      t.string :color

      t.timestamps
    end
  end
end
