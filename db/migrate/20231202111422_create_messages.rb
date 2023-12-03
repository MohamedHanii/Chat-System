class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :message_body
      t.decimal :message_number
      t.integer :chat_id

      t.timestamps
    end
  end
end
