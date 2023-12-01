class Application < ApplicationRecord
    has_many :chats, dependent: :destroy

    after_save :update_chat_count_after_save
    after_destroy :update_chat_count_after_destroy
    

    def update_chat_count_after_save
        update_chat_count
      end
    
      def update_chat_count_after_destroy
        update_chat_count
      end
    
      def update_chat_count
        update_column(:chat_count, chats.count)
      end
end
