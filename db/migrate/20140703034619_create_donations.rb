class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.string :name
      t.decimal :amount, :precision => 6, :scale => 2
      t.string :date

      t.timestamps
    end
  end
end
