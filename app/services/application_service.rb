class ApplicationService

    def initialize(application_repository = ApplicationRepository.new)
        @application_repository = application_repository
    end


    def get_all_applications
        return @application_repository.get_all
    end

    def get_application_by_token(token)
        return @application_repository.get_by_token(token) || nil
    end

    def create_application(params)
        # Create Token
        loop do
            @unique_identifier = SecureRandom.hex(8)
            break unless @application_repository.is_token_exists(@unique_identifier)
        end
        return @application_repository.create_application(params[:name],@unique_identifier)       
    end

    def update_application(app,params)
        if app
            app.name = params[:name]
            app.save
        end
        return app
    end


    def destory_application(app)
        if app
            app.destroy
        end
    end


end