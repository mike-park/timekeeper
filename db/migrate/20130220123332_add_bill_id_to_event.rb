class AddBillIdToEvent < ActiveRecord::Migration

  class Event < ActiveRecord::Base
    belongs_to :bill
  end
  class BillItem < ActiveRecord::Base
    belongs_to :event
  end
  class Bill < ActiveRecord::Base
    has_many :bill_items
  end

  def up
    add_column :events, :bill_id, :integer
    add_index :events, :bill_id
    remove_column :events, :billed_on

    Bill.all.each do |bill|
      bill.bill_items.all.each do |bi|
        bi.event.update_attribute(:bill_id, bill.id)
      end
    end
  end

  def down
    remove_index :events, :bill_id
    remove_column :events, :bill_id
    add_column :events, :billed_on, :date
  end
end
