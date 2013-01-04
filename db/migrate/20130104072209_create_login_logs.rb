class CreateLoginLogs < ActiveRecord::Migration
  def change
    create_table :login_logs do |t|
      t.integer :user_id
      t.string :user_name

      t.timestamps
    end
  end
end
