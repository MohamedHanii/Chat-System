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

    def create_new_chat(app,name)
        chat = @chat_repository.create_new_chat(app,name,app.chats.length())
        chat.save
        return chat
    end

    def update_chat(app,params)
        chat = @chat_repository.get_chat_by_number(app,params[:chatNumber])
        chat.chat_name = params[:name]
        chat.save
        return chat
    end


    def delete_chat(app,chat_number)
        chat = @chat_repository.get_chat_by_number(app,chat_number)
        chat.destroy
        return chat
    end
end