class CreateSearchWords < ActiveRecord::Migration
  def change
    create_table :search_words do |t|
      t.string :content
      t.integer :search_count

      t.timestamps
    end
  end
end
