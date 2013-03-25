class AddFingerprintToClient < ActiveRecord::Migration
  def change
    add_column :clients, :fingerprint, :string
    add_column :clients, :full_name, :string
    add_index :clients, :fingerprint
    add_index :clients, [:last_name, :first_name]
  end
end
