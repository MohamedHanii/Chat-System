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
        key = "last_message_count#{chat.id}"
        begin
          $redis.multi do
            $redis.watch(key)
            last_message_count = $redis.get(key).to_i || @message_repository.last_message_number(chat.id)
            # Increment chat count
            last_message_count += 1
      
            # Set the updated count in the transaction
            $redis.set(key, last_message_count)
      
            # Create new chat object
            new_message = @message_repository.create_new_message(chat,message_body)
            new_message.message_number = last_message_count
      
            object_params = {
              'key': chat.to_json,
              'object': new_message.to_json,
            }.to_json

      
            ObjectCreationWorker.perform_async('Message', object_params)
            incr_count(chat)
            return last_message_count
          end
        rescue Redis::CommandError
          # Another client modified the key while we were watching
          retry
        end
    end


    def update_message(chat,params)
        message = @message_repository.get_by_number(chat,params[:message_number])
        if message == nil
            return message
        end
        message.message_body = params[:message]
        message.save
        return message
    end

    def destory_message(chat,message_number)

        message = @message_repository.get_by_number(chat,message_number)
        if message == nil
            return message
        end
        decr_count(chat)
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