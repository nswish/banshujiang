class AddColumnAttrIdToValueSetHeader < ActiveRecord::Migration
  def change
    add_column :value_set_headers, :attr_id, :integer
  end
end
