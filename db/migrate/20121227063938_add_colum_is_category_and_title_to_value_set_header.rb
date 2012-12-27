class AddColumIsCategoryAndTitleToValueSetHeader < ActiveRecord::Migration
  def change
    add_column :value_set_headers, :title, :string
    add_column :value_set_headers, :is_category, :boolean
  end
end
