class AddColumnProgrammingLanguageToEBook < ActiveRecord::Migration
  def change
    add_column :e_books, :programming_language, :string
  end
end
