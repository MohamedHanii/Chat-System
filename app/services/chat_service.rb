class ChatService

    def initialize(application_repository = ApplicationRepository.new, chat_repository = ChatRepository.new)
        @application_repository = application_repository
        @chat_repository = chat_repository
    end

    def get_all_chat_for_app(app)
        return @chat_repository.get_all(app)
    end

    def get_chat_by_number(app,chat_number)
        return @chat_repository.get_chat_by_number(app,chat_number) 
    end

    def create_new_chat(app, name)
        key = "last_chat_count_#{app.token}"
      
        begin
          $redis.multi do
            $redis.watch(key)
            last_chat_count = $redis.get(key).to_i || @chat_repository.get_last_chat_num(app.token)
            # Increment chat count
            last_chat_count += 1
      
            # Set the updated count in the transaction
            $redis.set(key, last_chat_count)
      
            # Create new chat object
            new_chat = @chat_repository.create_new_chat(app, name)
            new_chat.chat_number = last_chat_count
      
            object_params = {
              'key': app.to_json,
              'object': new_chat.to_json,
            }.to_json
      
            ObjectCreationWorker.perform_async('Chat', object_params)
            incr_count(app)
            return last_chat_count
          end
        rescue Redis::CommandError
          # Another client modified the key while we were watching
          retry
        end
    end
  
    def update_chat(app,params)
        chat = @chat_repository.get_chat_by_number(app,params[:chat_number])
        if chat == nil
            return chat
        end
        chat.chat_name = params[:name]
        chat.save
        return chat
    end


    def delete_chat(app,chat_number)
        chat = @chat_repository.get_chat_by_number(app,chat_number)
        if chat == nil
            return chat
        end
        chat_count = decr_count(app)
        chat.destroy
        return chat
    end

    def incr_count(app)
        $redis.multi do
          $redis.sadd("chat_count", app.token)
          $redis.set(app.token, 0) unless $redis.get(app.token)
          chat = $redis.incr(app.token)
          chat
        end
    end
      
    def decr_count(app)
        $redis.multi do
            $redis.sadd("chat_count", app.token)
            $redis.set(app.token, 0) unless $redis.get(app.token)
            chat_count = $redis.decr(app.token)
            chat_count
        end
    end

end