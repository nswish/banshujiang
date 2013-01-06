class AddColumnDatabaseToEBook < ActiveRecord::Migration
  def change
    add_column :e_books, :database, :string
  end
end
