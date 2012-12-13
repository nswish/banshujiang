class CreateWebstorageLinks < ActiveRecord::Migration
  def change
    create_table :webstorage_links do |t|
      t.integer :e_book_id
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
