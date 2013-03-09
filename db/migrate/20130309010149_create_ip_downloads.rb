class CreateIpDownloads < ActiveRecord::Migration
  def change
    create_table :ip_downloads do |t|
      t.string :ip
      t.integer :e_book_id
      t.string :e_book_name
      t.string :location

      t.timestamps
    end
  end
end
