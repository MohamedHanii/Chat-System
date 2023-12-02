class MessagesController < ApplicationController
    before_action :initialize, :set_chat

    # list all Messages
    # GET /api/v1/applications/:token/chats/:chatNumber/messages
    def index
        messages = @message_service.get_all_messages(@chat)
        json_render(messages)
    end                                     

  # Show Specific Message
  # GET /api/v1/applications/:token/chats/:chatNumber/messages/:messageNumber
    def show                   
        message = @message_service.get_message_by_number(@chat,params[:message_number])                                                                  
        json_render(message)                                    
    end

 
   # Create New Message
   # POST /api/v1/applications/:token/chats/:chatNumber/messages
   def create 
        newMessage = @message_service.create_new_message(@chat,params[:message])
        json_render(@newMessage)
   end
 
   
   # Update Message
   # PUT /api/v1/applications/:token/chats/:chatNumber/messages/:messageNumber
   def update
        message = @message_service.update_message(@chat,params)
        json_render(message)
   end
   
   #Delete Message 
    def destroy
        message = @message_service.destory_message(@chat,params[:message_number])
        json_render(@chat)
    end



   private

    def initialize
        @chat_service = ChatService.new
        @application_service = ApplicationService.new
        @message_service = MessageService.new
    end

    def set_chat 
        puts params
        @app = @application_service.get_application_by_token(params[:token])
        if @app
            @chat = @chat_service.get_chat_by_number(params[:chat_number])
        end
    end


    def json_render(reply)
        render json: reply.as_json(:except => [:id, :chat_id])
    end

end
