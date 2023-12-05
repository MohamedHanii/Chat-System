class Message < ApplicationRecord
    belongs_to :chat

    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    
    settings index: { number_of_shards: 1 } do
      mappings dynamic: 'false' do
        indexes :chat_id, type: :integer
        indexes :message_body, type: :text
      end
    end

    def self.search_messages(chat_id, message_body)
      __elasticsearch__.search(
        query: {
          bool: {
            must: [
              { match: { chat_id: chat_id } },
              { match: { message_body: message_body } }
            ]
          }
        }
      ).records
    end
  
end
