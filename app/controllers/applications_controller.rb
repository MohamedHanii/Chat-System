class ApplicationsController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_app

    # list all applications
    #GET /api/v1/applications
    def index
        apps = @application_service.get_all_applications
        json_render(apps)
    end

    #Show specific application
    #GET /api/v1/applications/:token
    def show 
        json_render(@app)
    end

    #Create Application
    #POST /api/v1/applications
    def create 
        app = @application_service.create_application(params)
        json_render(app)
    end

    #Update Application with Token
    #PUT /api/v1/applications/:token
    def update
         app = @application_service.update_application(@app,params)   
        json_render(app)
    end
  
    # Delete Application with Token
    #DELETE /api/v1/applications/:token
    def destroy
        @application_service.destory_application(@app)

        json_render(@app)
    end


  private 

    def set_app 
        puts params
        @application_service = ApplicationService.new
        @app = @application_service.get_application_by_token(params)
    end


    def json_render(reply)
        render json: reply.as_json(:except => :id)
    end
end
