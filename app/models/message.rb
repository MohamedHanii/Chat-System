class Message < ApplicationRecord
    belongs_to :chat

    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    
    settings index: { number_of_shards: 1 } do
      mappings dynamic: 'false' do
        indexes :message_body, type: 'text', analyzer: 'custom_analyzer'
      end
    end
  
    def as_indexed_json(options = {})
      self.as_json(only: [:id, :message_body, :message_number])
    end
end
