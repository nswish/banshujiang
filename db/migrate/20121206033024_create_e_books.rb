class CreateEBooks < ActiveRecord::Migration
  def change
    create_table :e_books do |t|
      t.string :name
      t.string :language
      t.string :author
      t.string :format
      t.string :image_large
      t.string :image_small

      t.timestamps
    end
  end
end
