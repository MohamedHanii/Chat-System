class ChatRepository

    def initialize() 
    end


    def get_all(app)
        app.chats.all
    end

    def get_chat_by_number(app,chat_number)
        app.chats.find_by(chat_number: chat_number)
    end

    def create_new_chat(app,name,chat_number)
        app.chats.build(chat_name: name, chat_number: chat_number)
    end

    def last_chat_number(app)
        last_chat = app.chats.order(:chat_number).last
        last_chat ? last_chat.chat_number : 0
    end
    
end