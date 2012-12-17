class CreateValueSetBodies < ActiveRecord::Migration
  def change
    create_table :value_set_bodies do |t|
      t.integer :value_set_header_id
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
