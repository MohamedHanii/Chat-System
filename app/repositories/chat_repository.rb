class ChatRepository

    def initialize() 
    end


    def get_all(app)
        app.chats.all
    end

    def get_chat_by_number(app,chat_number)
        app.chats.find_by(chat_number: chat_number)
    end

    def create_new_chat(app,name)
        app.chats.build(chat_name: name,message_count:  0)
    end

    def last_chat_number(token)
        app = Application.find_by(token: token)
        last_chat = app.chats.order(:chat_number).last
        last_chat ? last_chat.chat_number : 0
    end
    
end