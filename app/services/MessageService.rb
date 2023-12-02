class MessageService
    
    def initialize(message_repository = MessageRepository.new)
        @message_repository = message_repository
    end
    
    def get_all_messages(chat)
        return @message_repository.get_all(chat)
    end

    def get_message_by_number(chat,message_number)
        return @message_repository.get_by_number(chat,message_number)
    end


    def create_new_message(chat,message_body)
        new_message = @message_repository.create_new_message(chat,message_body,chat.messages.length())
        new_message.save
        return new_message
    end


    def update_message(chat,params)
        message = @message_repository.get_by_number(chat,params[:message_number])
        message.message_body = params[:message]
        message.save
        return message
    end

    def destory_message(chat,message_number)
        message = @message_repository.get_by_number(chat,message_number)
        message.destroy
        return message
    end
end