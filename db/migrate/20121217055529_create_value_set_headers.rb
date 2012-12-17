class CreateValueSetHeaders < ActiveRecord::Migration
  def change
    create_table :value_set_headers do |t|
      t.string :name

      t.timestamps
    end
  end
end
