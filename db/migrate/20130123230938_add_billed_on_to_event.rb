class AddBilledOnToEvent < ActiveRecord::Migration
  def change
    add_column :events, :billed_on, :date
  end
end
