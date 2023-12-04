class ApplicationsController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_app

    # list all applications
    #GET /api/v1/applications
    def index
        apps = @application_service.get_all_applications
        json_render(apps,:ok)
    end

    #Show specific application
    #GET /api/v1/applications/:token
    def show 
        if @app == nil
            render json: { error: 'Application not found' }, status: :not_found
        else
            json_render(@app,:ok)
        end
    end

    #Create Application
    #POST /api/v1/applications
    def create 
        app = @application_service.create_application(params)
        if app != nil
            json_render(app,:created)
        else
            render json: { error: 'error in creating' }, status: :bad_request
        end
    end

    #Update Application with Token
    #PUT /api/v1/applications/:token
    def update
        if @app == nil
            return render json: { error: 'Application not found' }, status: :not_found
        end
         app = @application_service.update_application(@app,params)   
        json_render(app,:ok)
    end
  
    # Delete Application with Token
    #DELETE /api/v1/applications/:token
    def destroy
        if @app == nil
            return render json: { error: 'Application not found' }, status: :not_found
        else
            @application_service.destory_application(@app)
            head :no_content
        end
    end


  private 

    def set_app 
        @application_service = ApplicationService.new
        @app = @application_service.get_application_by_token(params[:token])
    end


    def json_render(reply,status)
        render json: reply.as_json(:except => :id), status: status
    end


    
end
