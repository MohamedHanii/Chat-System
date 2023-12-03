class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :token
      t.string :name
      t.decimal :chat_count

      t.timestamps
    end
  end
end
