class ChatService

    def initialize(application_repository = ApplicationRepository.new, chat_repository = ChatRepository.new)
        @application_repository = application_repository
        @chat_repository = chat_repository
    end

    def get_all_chat_for_app(app)
        return @chat_repository.get_all(app)
    end

    def get_chat_by_number(app,chat_number)
        
        return @chat_repository.get_chat_by_number(app,chat_counts) 
    end

    def create_new_chat(app,name)
        chat = nil
        chat_counts = incr_count(app)

        ActiveRecord::Base.transaction do
          last_chat_number = @chat_repository.last_chat_number(app)
          chat = @chat_repository.create_new_chat(app, name, last_chat_number + 1)
          chat.save
        end

        chat
    end

    
    def update_chat(app,params)
        chat = @chat_repository.get_chat_by_number(app,params[:chat_number])
        chat.chat_name = params[:name]
        chat.save
        return chat
    end


    def delete_chat(app,chat_number)
        chat_count = decr_count(app)
        chat = @chat_repository.get_chat_by_number(app,chat_number)
        chat.destroy
        return chat
    end

    def incr_count(app)
        chat_count = 1
        $redis.watch(app.token) do
            if $redis.get(app.token).nil?
                $redis.multi do
                    $redis.sadd("chat_count", app.token)
                    $redis.set(app.token, app.chat_count)
                end
            end
            chat_count = $redis.incr(app.token)
        end
        $redis.unwatch
        chat_count
    end

    def decr_count(app)
        chat_count = 0
      
        $redis.watch(app.token) do
          if $redis.get(app.token).nil?
            $redis.multi do
              $redis.sadd("chat_count", app.token)
              $redis.set(app.token, app.chatCount)
            end
          end
      
          chat_count = $redis.decr(app.token)
        end
      
        $redis.unwatch
        chat_count
    end
end