class AddAdLinkToWebstorageLink < ActiveRecord::Migration
  def change
    add_column :webstorage_links, :ad_link, :string
  end
end
