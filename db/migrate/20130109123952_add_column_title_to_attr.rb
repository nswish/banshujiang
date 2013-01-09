class AddColumnTitleToAttr < ActiveRecord::Migration
  def change
    add_column :attrs, :title, :string
  end
end
