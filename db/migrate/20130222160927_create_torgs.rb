class CreateTorgs < ActiveRecord::Migration
  def change
    create_table :torgs do |t|
      t.date :start_date
      t.date :end_date
      t.text :report

      t.timestamps
    end
    add_index :torgs, [:start_date, :end_date]
  end
end
