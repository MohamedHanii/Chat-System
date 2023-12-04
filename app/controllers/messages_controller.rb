class MessagesController < ApplicationController
    protect_from_forgery with: :null_session                                                                        
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
        if message == nil
            return render json: { error: 'Message number not found' }, status: :not_found       
        end                                                      
        json_render(message)                                    
    end

 
   # Create New Message
   # POST /api/v1/applications/:token/chats/:chatNumber/messages
   def create 
        new_message = @message_service.create_new_message(@chat,params[:message])
        render json: {message_number: new_message}, status: :created
   end
 
   
   # Update Message
   # PUT /api/v1/applications/:token/chats/:chatNumber/messages/:messageNumber
   def update
        message = @message_service.update_message(@chat,params)
        if message == nil
            return render json: { error: 'Message number not found' }, status: :not_found  
        end
        json_render(message)
   end
   
   #Delete Message 
    def destroy
        message = @message_service.destory_message(@chat,params[:message_number])
        if message == nil
            return render json: { error: 'Message number not found' }, status: :not_found  
        end
        head :no_content
    end

    def search
        json_render(@messages = @chat.messages.search(params[:q]))
    end

   private

    def initialize
        @chat_service = ChatService.new
        @application_service = ApplicationService.new
        @message_service = MessageService.new
    end

    def set_chat 
        @app = @application_service.get_application_by_token(params[:application_token])
        if @app == nil
            return render json: { error: 'Application not found' }, status: :not_found
        end

        @chat = @chat_service.get_chat_by_number(@app,params[:chat_chat_number])
        if @chat == nil
            return render json: { error: 'Chat number not found' }, status: :not_found
        end
    end


    def json_render(reply)
        render json: reply.as_json(:except => [:id, :chat_id])
    end

end
