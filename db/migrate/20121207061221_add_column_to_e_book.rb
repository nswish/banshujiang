class AddColumnToEBook < ActiveRecord::Migration
  def change
    add_column :e_books, :publish_date, :date
  end
end
