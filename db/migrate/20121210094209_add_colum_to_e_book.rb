class AddColumToEBook < ActiveRecord::Migration
  def change
    add_column :e_books, :download_name_2, :string
    add_column :e_books, :download_url_2, :string
  end
end
