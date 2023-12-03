class UpdateDatabaseCountWorker
  include Sidekiq::Worker

  def perform(*args)
    puts 'Starting count job'
  
    # Process 'chat_count'
    puts $redis.smembers('chat_count')
    app_tokens = $redis.smembers('chat_count')
  
    app_tokens.each do |token|
      $redis.watch(token) do
        curr = Application.find_by(token: token)
  
        if curr
          stored_value = $redis.get(token).to_i
          new_value = curr.chat_count + stored_value
          $redis.multi do
            $redis.set(token, 0)
            curr.update(chat_count: new_value)
          end
        end
  
        $redis.srem('chat_count', token)
      end
    end
  
    # Process 'message_count'
    puts 'Updating messages'
    puts $redis.smembers('message_count')
    chat_ids = $redis.smembers('message_count')
  
    chat_ids.each do |chat_id|
      $redis.watch(chat_id) do
        curr_chat = Chat.find_by(id: chat_id)
  
        if curr_chat
          stored_value = $redis.get(chat_id).to_i
          new_value = stored_value # Assuming it's a direct replacement in this case
  
          $redis.multi do
            $redis.set(chat_id, 0)
            curr_chat.update(message_count: new_value)
          end
        end
  
        $redis.srem('message_count', chat_id)
      end
    end
  end
  
end
