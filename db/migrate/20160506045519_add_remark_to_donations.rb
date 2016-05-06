class AddRemarkToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :remark, :string
  end
end
