class CreateEBookAttrs < ActiveRecord::Migration
  def change
    create_table :e_book_attrs do |t|
      t.integer :e_book_id
      t.integer :attr_id
      t.string :value

      t.timestamps
    end
  end
end
