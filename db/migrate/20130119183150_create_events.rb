class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :therapist
      t.references :event_category
      t.references :user
      t.date :occurred_on
      t.references :client

      t.timestamps
    end
    add_index :events, :therapist_id
    add_index :events, :event_category_id
    add_index :events, :user_id
    add_index :events, :client_id
  end
end
