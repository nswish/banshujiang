class AddColumnPublishYearToEBook < ActiveRecord::Migration
  def change
    add_column :e_books, :publish_year, :integer
  end
end
