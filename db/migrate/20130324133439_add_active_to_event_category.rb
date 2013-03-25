class AddActiveToEventCategory < ActiveRecord::Migration
  def change
    add_column :event_categories, :active, :boolean, default: true
    EventCategory.update_all(active: true)
  end
  def down
    remove_column :event_categories, :active
  end
end
