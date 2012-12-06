class CreateEBooks < ActiveRecord::Migration
  def change
    create_table :e_books do |t|
      t.string :name
      t.date :publish_data
      t.string :language
      t.string :author
      t.string :publisher
      t.string :format
      t.string :image_large
      t.string :image_small
      t.string :download_url
      t.string :download_name

      t.timestamps
    end
  end
end
