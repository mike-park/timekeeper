class AddActiveToClients < ActiveRecord::Migration
  class Client < ActiveRecord::Base
  end
  def up
    add_column :clients, :active, :boolean, default: true
    Client.update_all(active: true)
  end
  def down
    remove_column :clients, :active
  end
end
