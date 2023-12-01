class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.string :chat_name
      t.integer :chat_number
      t.integer :messages_count
      t.integer :application_id

      t.timestamps
    end
  end
end
