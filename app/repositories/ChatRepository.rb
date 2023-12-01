class ChatRepository

    def initialize() 
    end


    def get_all(app)
        return app.chats.all
    end

    def get_chat_by_number(app,chat_number)
        return app.chats.find_by(chat_number: chat_number)
    end

    def create_new_chat(app,name,chat_number)
        return app.chats.build(chat_name: name, chat_number: chat_number)
    end
end