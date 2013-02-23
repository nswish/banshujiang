class AddDownloadCountToEBook < ActiveRecord::Migration
  def change
    add_column :e_books, :download_count, :integer
  end
end
