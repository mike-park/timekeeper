class CreateTherapists < ActiveRecord::Migration
  def change
    create_table :therapists do |t|
      t.string :first_name
      t.string :last_name
      t.string :abbrv

      t.timestamps
    end
  end
end
