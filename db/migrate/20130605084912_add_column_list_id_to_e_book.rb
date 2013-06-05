class AddColumnListIdToEBook < ActiveRecord::Migration
  def change
    add_column :e_books, :list_id, :integer
  end
end
