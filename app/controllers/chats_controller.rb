class ChatsController < ApplicationController
    protect_from_forgery with: :null_session                                                                        
    before_action :initialize, :set_app

    # List All Chats for Application
    # GET api/v1/applications/:token/chats
    def index
        json_render(@chat_service.get_all_chat_for_app(@app))
    end

    # List a single specific Chat inside application
    # GET api/v1/applications/:token/chats/:chatNumber
    def show 
        chat = @chat_service.get_chat_by_number(@app,params[:chatNumber])
        json_render(chat)
    end


    # Create New Chat
    # POST api/v1/applications/:token/chats
    def create 
        newChat = @chat_service.create_new_chat(@app,params[:name])
        json_render(newChat)
    end


    # Update Chat
    # PUT api/v1/applications/:token/chats/:chatNunber
    def update
        chat = @chat_service.update_chat(@app,params)
        json_render(chat)
    end

    # Update Chat
    # DELETE api/v1/applications/:token/chats/:chatNunber
    def destroy
        chat = @chat_service.delete_chat(@app,params[:chatNumber])  
        json_render(chat)
    end


    private

    def initialize
        @chat_service = ChatService.new
        @application_service = ApplicationService.new
    end

    def set_app 
        @app = @application_service.get_application_by_token(params[:token])
    end

    def json_render(reply)
        puts params
        render json: reply.as_json(:except => [:id, :application_id])
    end
end
