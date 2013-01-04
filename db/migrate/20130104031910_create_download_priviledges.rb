class CreateDownloadPriviledges < ActiveRecord::Migration
  def change
    create_table :download_priviledges do |t|
      t.integer :e_book_id
      t.integer :user_id
      t.timestamp :expiration_at

      t.timestamps
    end
  end
end
