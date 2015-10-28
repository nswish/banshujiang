class AddFileFormatToWebstorageLinks < ActiveRecord::Migration
  def change
    add_column :webstorage_links, :file_format, :string
  end
end
