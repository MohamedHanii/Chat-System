class UpdateDatabaseCountWorker
  include Sidekiq::Worker

  def perform(*args)
    puts 'Starting count job'
  
    # Use a Redis pipeline for improved performance
    $redis.pipelined do
      app_tokens = $redis.smembers('chat_count')
      app_tokens.each do |token|
        puts token
        $redis.multi do
          curr = Application.find_by(token: token)
          if curr
            curr.chat_count = $redis.get(token)
            curr.save
          end
          $redis.srem('chat_count', token)
        end
      end
  
      puts 'Updating messages'
  
      chat_ids = $redis.smembers('message_counts')
      chat_ids.each do |chat_id|
        $redis.multi do
          curr_chat = Chat.find_by(id: chat_id)
          if curr_chat
            curr_chat.message_count = $redis.get(chat_id)
            curr_chat.save
          end
          $redis.srem('message_counts', chat_id)
        end
      end
    end
  end
end
