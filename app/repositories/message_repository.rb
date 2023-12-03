class MessageRepository

    def initialize() 
    end


    def get_all(chat)
        return chat.messages.all
    end

    def get_by_number(chat,message_number)
        return chat.messages.find_by(message_number: message_number)
    end

    def create_new_message(chat,message_body,message_number)
        return chat.messages.build(message_body: message_body, message_number: message_number)
    end
    
    def last_message_number(chat)
        last_message = chat.messages.order(:message_number).last
        last_message ? last_message.message_number : 0
    end
end