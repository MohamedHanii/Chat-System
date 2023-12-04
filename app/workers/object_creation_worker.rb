class ObjectCreationWorker
    include Sidekiq::Worker
  
    def perform(modelName, object_params)
        model = modelName.constantize
        object = JSON.parse(object_params)
        record = JSON.parse(object['object'])
        parent = JSON.parse(object['parent'])
        ActiveRecord::Base.transaction do
            if modelName=='Chat'
                @chat_repository = ChatRepository.new
                record['chat_number'] = @chat_repository.last_chat_number(parent['token'])+1
            else
                @message_repository = MessageRepository.new
                record['message_number'] = @message_repository.last_message_number(parent['id'])+1
            end
            model.new(record).save!
        end
    end

  end