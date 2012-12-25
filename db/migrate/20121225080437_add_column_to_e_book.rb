class AddColumnToEBook < ActiveRecord::Migration
  def change
    add_column :e_books, :mobile_development, :string
  end
end
