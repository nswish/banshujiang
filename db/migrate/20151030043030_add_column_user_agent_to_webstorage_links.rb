class AddColumnUserAgentToWebstorageLinks < ActiveRecord::Migration
  def change
    add_column :webstorage_links, :user_agent, :string
  end
end
