class AddColumnIpAgeScoreKindToUser < ActiveRecord::Migration
  def change
    add_column :users, :ip, :string
    add_column :users, :age, :string
    add_column :users, :score, :integer
    add_column :users, :kind, :string
  end
end
