class AddColumnOperationSystemToEBook < ActiveRecord::Migration
  def change
    add_column :e_books, :operation_system, :string
  end
end
