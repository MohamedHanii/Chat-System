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
        new_message=nil
        incr_count(chat)
        ActiveRecord::Base.transaction do
            last_message_count = @message_repository.last_message_number(chat)
            new_message = @message_repository.create_new_message(chat,message_body,last_message_count+1)
            new_message.save
        end

        return new_message
    end


    def update_message(chat,params)
        message = @message_repository.get_by_number(chat,params[:message_number])
        message.message_body = params[:message]
        message.save
        return message
    end

    def destory_message(chat,message_number)
        decr_count(chat)
        message = @message_repository.get_by_number(chat,message_number)
        message.destroy
        return message
    end

    def incr_count(chat)
        $redis.multi do
          $redis.sadd("message_count", chat.id)
          $redis.set(chat.id, 0) unless $redis.get(chat.id)
          message_count = $redis.incr(chat.id)
          message_count
        end
    end
      
    def decr_count(chat)
        $redis.multi do
            $redis.sadd("message_count", chat.id)
            $redis.set(chat.id, 0) unless $redis.get(chat.id)
            message_count = $redis.decr(chat.id)
            message_count
        end
    end
end