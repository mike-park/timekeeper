class AddCategoryToTherapist < ActiveRecord::Migration
  def change
    add_column :therapists, :category, :string
    add_column :therapists, :full_name, :string
    add_column :therapists, :options, :text
  end
end
