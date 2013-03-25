class AddColumnSecretKeyToWebstorageLink < ActiveRecord::Migration
  def change
    add_column :webstorage_links, :secret_key, :string
  end
end
