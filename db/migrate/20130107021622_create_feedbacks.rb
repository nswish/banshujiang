class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.string :user_name
      t.text :content

      t.timestamps
    end
  end
end
